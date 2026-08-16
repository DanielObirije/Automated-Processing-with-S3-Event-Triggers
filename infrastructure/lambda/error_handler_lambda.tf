
data "archive_file" "error_handler_zip" {
  type = "zip"
  output_path ="${path.module}/error_handler.zip" 
  source {
   content = file("${path.module}/../../src/error_handler/handler.py")
   filename = "handler.py"
  }
}