resource "aws_codepipeline" "pipeline" {
  stage {
    name = "Source"

   action {
     name = "Source"
     category = "Source"
   }
  }
}
