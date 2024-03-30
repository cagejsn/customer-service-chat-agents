

resource "openai_assistant" "customer-support-agent" {
  name         = "Customer Support Agent"
  model        = "gpt-4-turbo-preview"
  instructions = "Your goal is to help with customer support"
  description  = "The customer support agent"
}

output "customer-support-agent" {
  value = openai_assistant.customer-support-agent
}

resource "openai_assistant" "audit-agent" {
  name         = "Ensures quality of Customer Support Agent"
  model        = "gpt-4-turbo-preview"
  instructions = "Your goal will be to ensure that the customer support agents you manage stay on topic"
  description  = "the audit agent"
}

output "audit-agent" {
  value = openai_assistant.audit-agent
}
