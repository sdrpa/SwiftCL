#if os(Linux)
import COpenCL
#else
import OpenCL
#endif

public class CLKernel {
   public let kernel: cl_kernel?

   public init(program: CLProgram, kernelName: String) throws {
      var status: cl_int = CL_SUCCESS
      self.kernel = kernelName.withCString() { cKernelName -> cl_kernel? in
         clCreateKernel(program.program, cKernelName, &status)
      }
      try CLError.check(status)
   }

   deinit {
      clReleaseKernel(kernel)
   }
}

extension CLKernel {
   public func setArg<T>(_ position: cl_uint, buffer: CLBuffer<T>) throws {
      let error = clSetKernelArg(kernel, position, MemoryLayout<cl_mem>.size, &(buffer.buffer))
      try CLError.check(error)
   }

   public func setArgs<T>(_ buffer: CLBuffer<T>...) throws {
      for (idx, item) in buffer.enumerated() {
         let error = clSetKernelArg(kernel, cl_uint(idx), MemoryLayout<cl_mem>.size, &(item.buffer))
         try CLError.check(error)
      }
   }
}
