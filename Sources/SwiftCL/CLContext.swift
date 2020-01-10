#if os(Linux)
import COpenCL
#else
import OpenCL
#endif

public class CLContext {
   public let context: cl_context

   public init(devices: [CLDevice]) throws {
      let numDevices = devices.count
      let deviceIds: [cl_device_id?] = devices.map {
         $0.deviceId
      }

      self.context = try deviceIds.withUnsafeBufferPointer { idBuffer -> cl_context in
         guard let idBase = idBuffer.baseAddress else {
            // TODO: throw valid error
            throw CLError(0)
         }
         var error: cl_int = CL_SUCCESS
         guard let newContext = clCreateContext(nil, cl_uint(numDevices), idBase, nil, nil, &error) else {
            // TODO: throw valid error
            throw CLError(0)
         }
         try CLError.check(error)

         return newContext
      }
   }

   public convenience init(device: CLDevice) throws {
      try self.init(devices: [device])
   }

   public init(type: cl_device_type) throws {
      var error: cl_int = CL_SUCCESS
      self.context = clCreateContextFromType(nil, type, nil, nil, &error)
      try CLError.check(error)
   }

   deinit {
      clReleaseContext(context)
   }
}

extension CLContext {
   public static func getDefault() throws -> CLContext {
      return try CLContext(type: cl_device_type(CL_DEVICE_TYPE_DEFAULT))
   }

   public func getInfo<T>(_ info: cl_context_info, type: T.Type) throws -> [T]? {
      // Determine the size of the value returned
      var valueSize: size_t = 0
      clGetContextInfo(context, cl_context_info(info), 0, nil, &valueSize)
      // Allocate memory for the value get the value
      let value = UnsafeMutablePointer<T>.allocate(capacity: valueSize / MemoryLayout<T>.size)
      defer { value.deallocate() }
      clGetContextInfo(context, cl_device_info(info), valueSize, value, nil)
      
      return Array<T>(UnsafeBufferPointer(start: value, count: valueSize))
   }
}
