variable "env" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev" 
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "LockTable"
}

variable "hash_key" {
  description = "Primary hash key for the DynamoDB table"
  type        = string
  default     = "LockID"
}

variable "hash_key_type" {
  description = "Type of the hash key (e.g., S for String)"
  type        = string
  default     = "S"
}
