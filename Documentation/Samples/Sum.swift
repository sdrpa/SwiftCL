import Foundation
import OpenCL
import SwiftCL

struct MyKernel {
   func run() {
      guard let device = CLDevice.default() else {
         exit(EXIT_FAILURE)
      }
      do {
         print("Using device: \(device)")
         let context = try CLContext(device: device)

         let aInput: [cl_float] = [1, 2, 3, 4]
         let bInput: [cl_float] = [5, 6, 7, 8]

         let a = try CLBuffer<cl_float>(context: context, readOnlyData: aInput)
         let b = try CLBuffer<cl_float>(context: context, readOnlyData: bInput)
         let c = try CLBuffer<cl_float>(context: context, count: 4)

         let source = """
            __kernel void add(__global const float *a,
                                    __global const float *b,
                                    __global float *c) {
               const uint i = get_global_id(0);
               c[i] = a[i] + b[i];
            };
            """

         let program = try CLProgram(context: context, programSource: source)
         try program.build(device)

         let kernel = try CLKernel(program: program, kernelName: "add")

         try kernel.setArgs(a, b, c)

         let queue = try CLCommandQueue(context: context, device: device)

         let range = NDRange(size: 4)
         try queue.enqueueNDRangeKernel(kernel, offset: NDRange(size: 0), global: range)

         let cResult = c.enqueueRead(queue)

         print("a: \(aInput)")
         print("b: \(bInput)")
         print("c: \(cResult)")

      } catch let error as CLError {
         print("Error \(error.status). \(error.description)")
      } catch let error {
         print(error.localizedDescription)
      }
   }
}
