import XCTest
import OpenCL
@testable import MyKernel

final class MyKernelTests: XCTestCase {
   let count = 1_000_000

   func testPerformanceGPU() {
      let xs = (0..<count).map { _ -> cl_float in Float.random(in: 1...count) }
      self.measure {
         MyKernel().run(xs: xs, ys: xs, count: count)
      }
   }

   func testPerformanceCPU() {
      let xs = (0..<count).map { _ in Float.random(in: 1...count) }
      self.measure {
         //var zs: [Float] = Array(repeating: 0, count: count)
         for i in 0..<count {
            //zs[i] = xs[i] + xs[i]
            _ = xs[i] + xs[i]
         }
      }
   }

   static var allTests = [
      ("testPerformanceGPU", testPerformanceGPU),
      ("testPerformanceCPU", testPerformanceCPU)
   ]
}

extension Float {
   static func random(in range: ClosedRange<Int>) -> Float {
      Float(Int.random(in: range))
   }
}
