# Azure OpenAI service using terraform

## To run the terraform scripts

1. Create a `terraform.tfvars` file in the project folder and fill the information like below.

   ```
   location        = "eastus"
   model_name      = "gpt-35-turbo"
   subscription_id = "<your_subscription_id>"
   deployment_name = "<any_name_for_deployed_model>"
   custom_subdomain_name = "<unique_custom_subdomain_name>"
   ```

2. Run the below commands

   ```
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

3. Ouput will be shown as below

   ```
   azureopenai_account_id = "<deployed_cognitive_account_id>"

   azureopenai_account_name = "azureopenai_cognitive_account"

   azureopenai_deployment_id = "<openai_deployment_id>"

   azureopenai_deployment_name = "<openai_deployment_name>"

   azureopenai_resource_group = "<resource_group_name>"

   endpoint_url = "<endpoint_of_cognitive_account>"
   ```

4. Deployed gpt-3.5-turbo model is only accessible from inside the virtual network. To test the output, a sample python script can be used like below that runs on a vm or other resource inside the virtual network.

   ```
   import os
   from openai import AzureOpenAI

   endpoint = os.getenv("ENDPOINT_URL", "<endpoint_url_from_output>")
   deployment = os.getenv("DEPLOYMENT_NAME", "<azureopenai_deployment_name_from_output>")
   subscription_key = os.getenv("AZURE_OPENAI_API_KEY","<primary_or_secondary_account_key>")

   # Initialize Azure OpenAI client with key-based authentication
   client = AzureOpenAI(
       azure_endpoint = endpoint,
       api_key = subscription_key,
       api_version = "2024-05-01-preview",
   )

   completion = client.chat.completions.create(
       model=deployment,
       messages= [
       {
           "role": "system",
           "content": "You are an AI assistant that helps people find information."
       },
       {
           "role": "user",
           "content": "Why japanese tourism is so popular?"
       }
   ],
   )

   print(completion.choices[0].message.content)
   ```
