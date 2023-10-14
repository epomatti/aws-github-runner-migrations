resource "aws_ecr_repository" "main" {
  name                 = "ecr-prisma-migrations"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
