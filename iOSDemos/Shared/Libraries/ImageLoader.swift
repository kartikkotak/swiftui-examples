import UIKit

// MARK: - Protocol definition
protocol ImageLoaderProtocol {
    init(session: URLSession, cacheLimit: Int)
    func fetch(url: String) async throws -> UIImage
}

// MARK: - Image Loader Implementation
actor ImageLoader: ImageLoaderProtocol {
    
    // MARK: - Properties
    private let imageCache: ImageCacher<NSString, UIImage>
    private let session: URLSession
    private var runningTasks: [String: Task<UIImage, Error>] = [:]
    
    // MARK: - Initializer
    init(session: URLSession = URLSession.shared, cacheLimit: Int = 200) {
        self.session = session
        self.imageCache = ImageCacher(countLimit: cacheLimit)
    }
    
    // MARK: - Public methods
    func fetch(url: String) async throws -> UIImage {
        // Return cached image if available
        if let image = await imageCache.object(for: NSString(string: url)) {
            return image
        }
        
        // If there is existing task then await result
        if let existingTask = runningTasks[url] {
            return try await existingTask.value
        }
        
        // Create new task to fetch and decode image data
        let task = Task<UIImage, Error>(priority: .userInitiated) { [session, weak self] in
            guard let urlObj = URL(string: url) else {
                throw URLError(.badURL)
            }
            let (data, response) = try await session.data(from: urlObj)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw URLError(.badServerResponse)
            }
            
            let image = try await Task.detached(priority: .utility) {
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                await self?.imageCache.set(image, for: .init(string: url))
                return image
            }.value
            
            return image
        }
        
        // Add new task to running task queue
        runningTasks[url] = task
        
        // remove the task from queue when awaited result is returned
        defer { runningTasks[url] = nil }
        
        // return awaited result value
        return try await task.value
    }
}
