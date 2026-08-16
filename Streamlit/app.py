# Frontend - Streamlit

import streamlit as st
from models import gemini

st.header('GEMINI APP')
st.subheader('Version 3.6 Flash')

# st.text_input("Enter your prompt", placeholder="What is data ?")
# st.text_area("Enter your prompt", placeholder="What is data ?")

prompt = st.text_area('Enter your prompt', placeholder='What is data ?')

# st.button
# success -> green, warning -> yellow, error -> red
if st.button('Send Prompt'):
    # st.toast('button clicked..')
    if prompt.strip() == '':
        st.warning('Pass any prompt value.')
    else:
        with st.spinner('Thinking'):
            try:
                answer = gemini(prompt)
                st.toast('Answer Generated.')
                st.write(answer)
            except Exception as e:
                st.toast(e)