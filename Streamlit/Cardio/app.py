import streamlit as st
import pandas as pd

from models import cardio


# -----------------------------
# Load Model
# -----------------------------

features, scaler, model, Y_pred, cr, cm = cardio()


# -----------------------------
# Page Title
# -----------------------------

st.header('Cardiovascular Disease Prediction')
st.subheader('Using Logistic Regression')


# -----------------------------
# Sidebar
# -----------------------------

st.sidebar.header('Cardio Features')


# Age
age = st.sidebar.slider(
    'Age',
    min_value=28,
    max_value=65,
    value=35,
    step=1
)


# Gender
gender_dict = {
    1: 'Female',
    2: 'Male'
}

gender = st.sidebar.radio(
    'Gender',
    options=list(gender_dict.keys()),
    format_func=lambda x: gender_dict.get(x)
)


# Height
height = st.sidebar.slider(
    'Height (Cm)',
    min_value=125,
    max_value=200,
    value=140,
    step=1
)


# Weight
weight = st.sidebar.slider(
    'Weight (Kg)',
    min_value=40,
    max_value=120,
    value=60,
    step=1
)


# Systolic Blood Pressure
ap_hi = st.sidebar.slider(
    'Systolic Pressure',
    min_value=100,
    max_value=200,
    value=120,
    step=1
)


# Diastolic Blood Pressure
ap_lo = st.sidebar.slider(
    'Diastolic Pressure',
    min_value=50,
    max_value=90,
    value=60,
    step=1
)


# Cholesterol
cholesterol_dict = {
    1: 'Low Cholesterol',
    2: 'Mild Cholesterol',
    3: 'High Cholesterol'
}

cholesterol = st.sidebar.radio(
    'Cholesterol',
    options=list(cholesterol_dict.keys()),
    format_func=lambda x: cholesterol_dict.get(x)
)


# Glucose
gluc_dict = {
    1: 'Low Glucose',
    2: 'Mild Glucose',
    3: 'High Glucose'
}

gluc = st.sidebar.radio(
    'Glucose',
    options=list(gluc_dict.keys()),
    format_func=lambda x: gluc_dict.get(x)
)


# Smoking
smoke_dict = {
    0: 'Does not Smoke',
    1: 'Does Smoke'
}

smoke = st.sidebar.radio(
    'Smoke',
    options=list(smoke_dict.keys()),
    format_func=lambda x: smoke_dict.get(x)
)


# Alcohol
alco_dict = {
    0: "Doesn't drink alcohol",
    1: 'Does drink alcohol'
}

alco = st.sidebar.radio(
    'Alcohol',
    options=list(alco_dict.keys()),
    format_func=lambda x: alco_dict.get(x)
)


# Physical Activity
active_dict = {
    0: "Doesn't do PA",
    1: 'Does Physical Activity'
}

active = st.sidebar.radio(
    'Physical Activities (PA)',
    options=list(active_dict.keys()),
    format_func=lambda x: active_dict.get(x)
)


# -----------------------------
# Prediction Button
# -----------------------------

if st.button('Predict Cardio'):

    # Create input DataFrame
    data = pd.DataFrame(
        [[
            age,
            gender,
            height,
            weight,
            ap_hi,
            ap_lo,
            cholesterol,
            gluc,
            smoke,
            alco,
            active
        ]],
        columns=features
    )


    # Scale input data
    data_scale = scaler.transform(data)


    # Prediction
    prediction = model.predict(data_scale)[0]


    # -------------------------
    # Display Result
    # -------------------------

    if prediction == 0:

        st.success(
            'No cardiovascular disease found.'
        )

    else:

        st.warning(
            'Cardiovascular disease found.'
        )