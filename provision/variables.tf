variable "project" {
  type    = string
  default = "default"
}

variable "pool" {
  type    = string
  default = "default"
}

variable "volume_size" {
  type    = string
  default = "30GB"
}

variable "cpu_limit" {
  type    = number
  default = 2
}

variable "memory_limit" {
  type    = string
  default = "2GB"
}