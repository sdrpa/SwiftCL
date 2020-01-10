import OpenCL

public class CLBuffer<T> {
   public var buffer: cl_mem

   private let size: Int
   private let count: Int

   public init(context: CLContext, memFlags: cl_mem_flags, data: [T]) throws {
      self.count = data.count
      self.size = MemoryLayout<T>.size * count

      var err: cl_int = CL_SUCCESS
      var localData = data
      self.buffer = clCreateBuffer(context.context, memFlags, size, &localData, &err)

      try CLError.check(err)
   }

   public convenience init(context: CLContext, readOnlyData: [T]) throws {
      try self.init(context: context, memFlags: cl_mem_flags(CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR), data: readOnlyData)
   }

   public init(context: CLContext, count: Int) throws {
      self.size = MemoryLayout<T>.size * count
      self.count = count

      var err: cl_int = CL_SUCCESS
      self.buffer = clCreateBuffer(context.context, cl_mem_flags(CL_MEM_WRITE_ONLY), size, nil, &err)

      try CLError.check(err)
   }

   deinit {
      clReleaseMemObject(buffer)
   }
}

extension  CLBuffer {
   public func enqueueRead(_ queue: CLCommandQueue) -> [T] {
      let elements = UnsafeMutablePointer<T>.allocate(capacity: count)
      defer { elements.deallocate() }
      clEnqueueReadBuffer(queue.queue, buffer, cl_bool(CL_TRUE), 0, size, elements, 0, nil, nil)
      return Array<T>(UnsafeBufferPointer(start: elements, count: count))
   }

   public func enqueueWrite(_ queue: CLCommandQueue, data: [T]) {
      // TODO: ...
   }
}
