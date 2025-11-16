# End-to-End Supply Chain Analytics (Python, MySQL, Power BI)

## Objective :
The objective of this Supply Chain Analytics Project is to build a complete end-to-end data pipeline and analytical system using Python, MySQL, and Power BI to improve supply chain 
efficiency and support data-driven business decisions. Cleaned and transformed raw data using Python, designed a relational database with a 6-table schema in MySQL, and performed advanced SQL
queries to analyze key supply chain metrics. Then visualized these insights in interactive Power BI dashboards. This analysis covers shipment performance, customer behavior, product 
profitability, regional revenue trends, supplier distribution, and operational KPIs across **13,500 orders, 1,600 customers, 126 products, 20 suppliers, and 10 warehouses**.
Through this project, demonstrated my ability to build ETL workflows, model relational databases, write complex SQL queries, calculate business-critical metrics (YOY sales, 
profit %, delivery performance), and convert raw data into meaningful insights that support strategic decision-making in logistics and supply chain operations.

![ER Diagram](https://github.com/harpreet-kaur87/SupplyChain/blob/main/er_diagram.png)
![Report 1](https://github.com/harpreet-kaur87/SupplyChain/blob/main/report_1.png)
![Report 2](https://github.com/harpreet-kaur87/SupplyChain/blob/main/report_2.png)
![Report 3](https://github.com/harpreet-kaur87/SupplyChain/blob/main/report_3.png)

## Key Insights:

### Shipment Analysis:

Processed **13,500 shipments** and classified delivery status as **Early, On-time, or Late based on expected delivery date**.

Found **3,440 early deliveries, 3,331 on-time deliveries, and 6,729 late deliveries**.

Identified **Ecom Express as the top performer for early deliveries** and **DTDC as the carrier with the highest late deliveries**.

Calculated average delivery time across all categories: 5–6 days.

### Supplier Insights:

Managed 20 suppliers across regions, with Central region hosting the highest number (5 suppliers).

West region had 4 suppliers; North, South, and East each had 3 suppliers.

### Customer Insights:

Total **1,600 customers**, with the South region having the highest number (294 customers).

Year-wise customer growth: **2023 → 665, 2024 → 660, 2025 → 275**.

Top 3 revenue-generating customers:

**Pooja Gupta: ₹1,091,082**

**Ravi Tiwari: ₹1,078,590**

**Rahul Patel: ₹1,071,476**

### Product and Category Analysis

Managed a total of **126 distinct products** in the supply chain.

**Electronics is the largest category with 38 products**, while Home Appliances is the smallest with 23 products.

### Revenue and profitability per category:

**Electronics: Revenue of 336.6 million, profit of 68.5 million, profit margin 20%**.

**Furniture: Revenue of 76.7 million, profit of 16.5 million, profit margin 21%**.

**Home Appliances: Revenue of 132.6 million, profit of 26.5 million, profit margin 20%**.

**Groceries: Revenue of 7.88 million, profit of 1.47 million, profit margin 19%**.

### Warehouse & Orders Analysis:

Operated 10 warehouses supporting the supply chain.

**Processed a total of 13,500 orders across 2023–2025**.

Year-wise order distribution:

2023: 2,031 orders

2024: 4,648 orders

2025: 6,821 orders

Year-on-year sales growth:

2023: 80.9 million

2024: 190.9 million → 136% growth

2025: 281.9 million → 48% growth

Regional Revenue Analysis:

### Revenue generated per region:

South: 104,860,399

North: 97,100,304

Central: 89,984,223

Northeast: 89,702,877

East: 88,128,330

West: 84,001,475

#### Technologies & Tools Used:

MySQL: Database design, aggregation queries, joins, group analysis, indexing

Python: Data cleaning, transformation, and ETL

Power BI: Interactive dashboarding, KPI visualization, drill-down analysis, and performance reporting

