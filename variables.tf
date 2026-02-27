variable "candidate_email" {
  description = "الإيميل الخاص بك المسجل لدى الشركة"
  type        = string
  default     = "cfnagib@outlook.de" 
}

variable "github_repo" {
  description = "رابط المستودع الخاص بك على جيت هاب"
  type        = string
  default     = "https://github.com/cfnagib/unleash-aws-assessment"
}

variable "project_name" {
  type    = string
  default = "unleash-assessment"
}