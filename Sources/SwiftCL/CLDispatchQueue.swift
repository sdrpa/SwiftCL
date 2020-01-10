import OpenCL

public struct CLDispatchQueue {
   public let queue: DispatchQueue

   public init(deviceType: Int32) {
      guard let queue = gcl_create_dispatch_queue(cl_queue_flags(deviceType), nil) else {
         fatalError("queue == nil")
      }
      self.queue = queue
   }

   public func getDevice() -> CLDevice {
      guard let deviceId = gcl_get_device_id_with_dispatch_queue(queue) else {
         fatalError("deviceId == nil")
      }
      return CLDevice(id: deviceId)
   }
}
