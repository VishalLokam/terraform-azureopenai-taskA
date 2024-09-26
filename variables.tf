variable "location" {
  description = "Location to deploy all the resource"
  default     = "eastus"
}

variable "model_name" {
  description = "OpenAI model name supported in the location"
  default     = "gpt-35-turbo"
}

variable "subscription_id" {
  description = "subscription id from Azure"
}

variable "deployment_name" {
  description = "name for the deployment"
  default     = "gpt35turbo_0125_deployment"
}

variable "custom_subdomain_name" {
  description = "name for the custom subdomain required for the private endpoint"
  default     = "schaefflerazureopenaiprivate"
}

