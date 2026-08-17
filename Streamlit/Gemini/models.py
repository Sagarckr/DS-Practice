from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise ValueError("GEMINI_API_KEY is not set")

print("API key loaded:", True)

from google import genai
client = genai.Client(api_key=api_key)

def gemini(text):
    interaction = client.interactions.create(
        model = "gemini-3.6-flash",
        input = text
    )
    return interaction.output_text

# print(gemini("Hello, Gemini!"))