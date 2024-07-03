# Cognitive-Framework
SUPSI - WP3 - T3.3

## Requirements

- [Python 3.10.12]
- [matplotlib 3.8.3]
- [numpy 1.26.4]
- [pandas 2.2.1]
- [scipy 1.12]
- [scikit-learn 1.4.1]
- [shap 0.45.1]
- [xgboost 2.0.3]

## General Description
The dataset we worked on is the Alibaba trace dataset 2023, available at this link:
https://github.com/alibaba/clusterdata/tree/master/cluster-trace-gpu-v2023

The dataset is composed of 8152 samples, and we decided to solve a classification problem to predict the target variable "pod_phase" (4 possible classes: running, failed, succeeded, pending) using 6 available features.
After performing the classification and evaluating the performances, we then calculated feature importances using SHAP, as mentioned above.

In our codes, to make predictions on the Alibaba dataset, we used Logistic Regression, K-Nearest Neighbors, Support Vector Machines, XGB, Random Forest, and LightGBM.
The winning model in terms of performance in cross-validation was XGB, so we focused on this.

For XGBoost, we improved performance and increased its robustness by using ensemble+bootstrapping.
After that, we also calculated the feature importances of XGBoost using SHAP.

## Deploy
### General Overview
1. The directory of the dataset to be loaded should be specified in line 2
2. From line 3 to 7 the code does preprocessing: scaling of the features, defining the target variable, creating numerica features for the categorical ones
3. From line 8 to 10 the code checks the performances of different ML models on the task at hand in terms of accuracy, f1-score, and confusion matrices. The XGBoost method appears to be the best one
4. From line 11 to 17 the code improves the performancies and the robustness of XGBoost for the problem at hand, by creating an ensemble of 100 XGBoost models through bootstrapping.
5. From line 18 to 24 the code compute feature importances through SHAP
