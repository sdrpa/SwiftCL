import Foundation
#if os(Linux)
import COpenCL
#else
import OpenCL
#endif
import SwiftCL

struct MyKernel {
   func run(xs: [cl_float], ys: [cl_float], count: Int) {
      guard let device = CLDevice.default() else {
         exit(EXIT_FAILURE)
      }
      do {
         //print("Using device: \(device)")
         let context = try CLContext(device: device)

         let a = try CLBuffer<cl_float>(context: context, readOnlyData: xs)
         let b = try CLBuffer<cl_float>(context: context, readOnlyData: ys)
         let c = try CLBuffer<cl_float>(context: context, count: count)

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

         let range = NDRange(size: count)
         try queue.enqueueNDRangeKernel(kernel, offset: NDRange(size: 0), global: range)

         let cResult = c.enqueueRead(queue)

         //guard let last = cResult.last else { fatalError() }
         //print("Done. Last: \(last)")

      } catch let error as CLError {
         print("Error \(error.status). \(error.description)")
      } catch let error {
         print(error.localizedDescription)
      }
   }
}
