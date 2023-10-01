resource "random_id" "cluster_random_id" {
  byte_length = 5
}

# Create a cluster-name with org region,environment and 5 byte random ID combination
locals {
  cluster_name = "${var.org_name}-${random_id.cluster_random_id.hex}-${var.region}-${var.environment}"
}