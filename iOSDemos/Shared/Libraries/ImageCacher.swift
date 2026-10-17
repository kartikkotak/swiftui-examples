import Foundation



actor ImageCacher<Key: AnyObject, Value: AnyObject> {
    
    typealias CacheFactory = @Sendable () -> NSCache<Key, Value>
    
    private let countLimit: Int
    private let cache: NSCache<Key, Value>
    
    init(countLimit: Int = 200, cacheFactory: CacheFactory = { NSCache<Key, Value>() }) {
        self.countLimit = countLimit
        self.cache = cacheFactory()
    }
    
    public func set(_ data: Value, for key: Key) {
        cache.setObject(data, forKey: key)
    }
    
    public func object(for key: Key) -> Value? {
        return cache.object(forKey: key)
    }
}
