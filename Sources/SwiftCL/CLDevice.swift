import OpenCL

public enum CLDeviceType {
   case cpu
   case gpu
   case all

   var nativeType: cl_device_type {
      switch self {
      case .all:
         return cl_device_type(CL_DEVICE_TYPE_ALL)
      case .gpu:
         return cl_device_type(CL_DEVICE_TYPE_GPU)
      case .cpu:
         fallthrough
      default:
         return cl_device_type(CL_DEVICE_TYPE_CPU)
      }
   }
}

public struct CLDevice {
   public let deviceId: cl_device_id

   public init(id: cl_device_id) {
      self.deviceId = id
   }

   public static func `default`(_ deviceType: CLDeviceType = .gpu) -> CLDevice? {
      return CLPlatform.all.first?.getDevices(deviceType).first
   }

   public var name: String {
      guard var chars: [CChar] = getDeviceInfo(CL_DEVICE_NAME) else {
         return "<No Device Name>"
      }
      return String(cString: &chars)
   }
}

extension CLDevice: CustomStringConvertible {
   public var description: String { name }
}

extension CLDevice {
   public static func getDefault(_ type: Int32) -> CLDevice {
      let queue = gcl_create_dispatch_queue(cl_queue_flags(type), nil)

      let deviceId = gcl_get_device_id_with_dispatch_queue(queue!)

      let device = CLDevice(id: deviceId!)
      return device
   }

   public func getDeviceInfo<T>(_ deviceInfo: Int32) -> [T]? {
      // Determine the size of the value returned
      var valueSize: size_t = 0
      clGetDeviceInfo(deviceId, cl_device_info(deviceInfo), 0, nil, &valueSize)
      // Allocate memory for the value and get the value
      let value = UnsafeMutablePointer<T>.allocate(capacity: valueSize)
      defer { value.deallocate() }
      clGetDeviceInfo(self.deviceId, cl_device_info(deviceInfo), valueSize, value, nil)
      // Convert the memory to a Swift array for easier handling
      return Array<T>(UnsafeBufferPointer(start: value, count: valueSize))
   }

   public func getDeviceInfo(_ deviceInfo: Int32) -> String? {
      if var cString: [CChar] = getDeviceInfo(deviceInfo) {
         return String(cString: &cString)
      }
      return nil
   }
}
