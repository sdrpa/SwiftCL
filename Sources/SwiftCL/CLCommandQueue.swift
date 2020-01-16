#if os(Linux)
import COpenCL
#else
import OpenCL
#endif

public struct CLCommandQueue {
   public let queue: cl_command_queue

   public init(context: CLContext, device: CLDevice, properties: cl_command_queue_properties = 0) throws {
      var error: cl_int = CL_SUCCESS
      queue = clCreateCommandQueue(context.context, device.deviceId, properties, &error)

      try CLError.check(error)
   }
}

extension CLCommandQueue {
   public func enqueueNDRangeKernel(_ kernel: CLKernel, offset: NDRange, global: NDRange) throws {
      var globalWorkOffset = offset.sizes[0]
      var globalWorkSize = global.sizes[0]
      //var localWorkSize = 32
      let error = clEnqueueNDRangeKernel(
         queue, // command_queue
         kernel.kernel, // kernel
         global.dimensions, // work_dim
         &globalWorkOffset, // global_work_offset
         &globalWorkSize, // global_work_size
         nil, //&localWorkSize,
         0,
         nil,
         nil)
      try CLError.check(error)
   }
}
