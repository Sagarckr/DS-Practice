# api

# Backedn -> Request
# Post (Create/Insert/Send)
# Get (Read),
# Put (Update),
# Delete (Remove)

import pandas as pd

from fastapi import FastAPI
from app.schema import CardioSchema
from app.model import load_logistic_model

# object for fastapi to use request function
app = FastAPI()

model, scaler = load_logistic_model()

# Get API for Home Page
@app.get('/')
def home():
    return 'Welcome to Cardiovascular disease prediction api.'

# Post/Send Request
@app.post('/predict-logistic-cardio')
def predictCardio(data: CardioSchema):
    input_data = pd.DataFrame([data.model_dump()])
    input_scaler = scaler.transform(input_data)
    prediction = model.predict(input_scaler)[0]
    return {
        'Prediction Stats': int(prediction),
        'Status': 'Likely to be Healthy' if prediction == 0
                   else 'Likely to be Unhealthy'
    }

