# Enterprise Fraud Detection – SQL System using PaySim Dataset
[![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue)](https://www.postgresql.org/)
[![Dataset Size](https://img.shields.io/badge/Records-6.3M-orange)]()


Built a scalable fraud detection system using SQL on 6.3M+ financial transactions from the PaySim dataset. Detected high-risk behavioral patterns, flagged ₹12B+ in fraudulent activity, and delivered actionable intelligence aligned with enterprise risk control frameworks.

---

## 📊 Key Business Insights

- **Total transactions analyzed:** 6,362,620
- **High-risk cases flagged:** ~8,213 (0.13%)
- **Flagged fraudulent volume:** ₹12B+
- **Transaction types involved:** 100% of fraud occurred in `TRANSFER` and `CASH_OUT`
- **Peak fraud window:** ₹4B+ stolen between 6 PM – 11 PM
- **Repeat receiver pattern:** One receiver flagged for ₹10M+ in multiple events
- **SQL-flagged volume:** ₹5.26B identified using logic-based rules

---

## 🧠 Approach & Detection Strategy

Analyzed transactional behavior using domain-driven SQL logic to identify:

- Sudden high-value transfers from ₹0 balance accounts
- Receivers whose post-transaction balances remain unchanged
- Frequent incoming transactions to the same user (fraud mules)
- Amount thresholds and time-based patterns that indicate abnormal activity

Custom flags like `is_suspicious` and `is_zero_balance` were created to segment risk-prone records and assist manual review.

---

## 📸 Visual Examples

<p align="center">
  <img src="screenshots/fraud_by_type.png" width="500"/>
  <br><em>Fraud exclusively occurred in TRANSFER and CASH_OUT types</em>
</p>

<p align="center">
  <img src="screenshots/hourly_fraud_distribution.png" width="500"/>
  <br><em>₹4B+ stolen during peak hours (6 PM – 11 PM)</em>
</p>

---


## 🛠 Tools & Technologies

- PostgreSQL / pgAdmin
- SQL (window functions, CASE, aggregations)
- Excel / Matplotlib (visualization)
- GitHub (versioning and project publishing)

---

## 💡 Business Recommendations

- Set dynamic transfer limits based on user history and time of day  
- Trigger alerts for large-value transfers from low-balance senders  
- Increase monitoring during 6 PM to 11 PM  
- Investigate high-frequency receivers with low change in balance

---



## 📁 Dataset Reference

- [PaySim Dataset – Kaggle](https://www.kaggle.com/datasets/ealaxi/paysim1)

---


## 🔎 Result

Delivered a business-aligned fraud detection system designed to mirror how real-world risk teams uncover and respond to anomalies in large-scale financial 
data using explainable, interpretable rules.

--

**Anmol Kirtiwardhan**  
🌐 Explore all my projects & live apps: [akwardhan.github.io](https://akwardhan.github.io)

---




