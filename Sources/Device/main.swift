import Foundation
import SwiftCL
import OpenCL

for platform in CLPlatform.all {
   for device in platform.getDevices(.all) {
      print("Using device \(device)")

      if let version = device.getDeviceInfo(CL_DEVICE_VERSION) {
         print("Hardware version: \(version)")
      }
      if let driverVersion = device.getDeviceInfo(CL_DRIVER_VERSION) {
         print("Driver version: \(driverVersion)")
      }
      if let cVersion = device.getDeviceInfo(CL_DEVICE_OPENCL_C_VERSION) {
         print("OpenCL C version: \(cVersion)")
      }
      if let maxComputeUnits: [cl_uint] = device.getDeviceInfo(CL_DEVICE_MAX_COMPUTE_UNITS) {
         print("Parallel compute units: \(maxComputeUnits)")
      }
   }
}
