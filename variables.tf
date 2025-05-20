variable "cloud_id" {
    type=string
    default="b1g8dhkoksraemsg21d1"
}
variable "folder_id" {
    type=string
    default="b1grhpvr018trna19v2f"
}

variable "test" {
    type=map(number)
    default={
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

