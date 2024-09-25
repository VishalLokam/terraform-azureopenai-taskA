import os
from openai import AzureOpenAI

endpoint = os.getenv("ENDPOINT_URL", "https://vishaltestazureopenaiprivate2.openai.azure.com/")
deployment = os.getenv("DEPLOYMENT_NAME", "azureopenai_cognitive_deployment")
subscription_key = os.getenv("AZURE_OPENAI_API_KEY", "1b18ef5685bd431b864e648141041ba4")

print(endpoint + "  " + deployment + " " + subscription_key )

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
        "content": "What is the capital of india?"
    }
],
)

print(completion.choices[0].message)