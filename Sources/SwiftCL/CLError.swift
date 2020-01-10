import OpenCL

public struct CLError: Error, CustomStringConvertible {
   public let status: cl_int
   public let description: String

   public init(_ status: cl_int, description: String? = nil) {
      self.status = status
      if let description = description {
         self.description = description
      } else {
         self.description = "No description"
      }
   }
}

extension CLError {
   static func check(_ errorCode: cl_int) throws {
      if errorCode != OpenCL.CL_SUCCESS {
         throw CLError(errorCode)
      }
   }
}
