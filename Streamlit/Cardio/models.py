import pandas as pd

from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, confusion_matrix


# Load dataset
df = pd.read_csv('Cardiovascular_Disease.csv')


# -----------------------------
# Data Cleaning
# -----------------------------

# Convert age from days to years
df['age'] = df['age'] // 365

# Filter unrealistic values
df = df[
    (df['height'].between(125, 200)) &
    (df['weight'].between(40, 120)) &
    (df['ap_hi'].between(100, 200)) &
    (df['ap_lo'].between(50, 90))
]


# -----------------------------
# Model Function
# -----------------------------

def cardio():

    # Features
    features = [
        'age',
        'gender',
        'height',
        'weight',
        'ap_hi',
        'ap_lo',
        'cholesterol',
        'gluc',
        'smoke',
        'alco',
        'active'
    ]

    # Target
    target = 'cardio'

    X = df[features]
    Y = df[target]


    # Train Test Split
    X_train, X_test, Y_train, Y_test = train_test_split(
        X,
        Y,
        test_size=0.2,
        random_state=42,
        stratify=Y
    )


    # Standard Scaling
    scaler = StandardScaler()

    X_train_scale = scaler.fit_transform(X_train)
    X_test_scale = scaler.transform(X_test)


    # Logistic Regression Model
    model = LogisticRegression(
        solver='lbfgs',
        class_weight='balanced',
        random_state=42
    )


    # Train Model
    model.fit(X_train_scale, Y_train)


    # Prediction
    Y_pred = model.predict(X_test_scale)


    # Evaluation
    cr = classification_report(
        Y_test,
        Y_pred
    )

    cm = confusion_matrix(
        Y_test,
        Y_pred
    )


    # Return all 6 values
    return features, scaler, model, Y_pred, cr, cm