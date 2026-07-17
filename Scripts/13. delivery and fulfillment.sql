/*
===============================================================================
 Script Name : 13. Delivery & Fulfillment.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Operational analysis of the order fulfilment process to evaluate
     delivery performance, logistics efficiency and customer service.

 Business Questions Answered
 ---------------------------
 1. How long does it take to approve an order?
 2. How long does it take sellers to dispatch orders?
 3. How long does delivery take after carrier pickup?
 4. What is the average end-to-end fulfilment time?
 5. Which states experience the longest delivery times?
 6. Which sellers have the fastest delivery times?
 7. How many deliveries were late?
 8. How many deliveries arrived on or before the estimated date?
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Q1. How long does it take to approve an order?
==============================================================================*/

SELECT

    ROUND
    (
        AVG
        (
            DATEDIFF
            (
                HOUR,
                purchase_timestamp,
                approval_timestamp
            )
        ),
        2
    ) AS Average_Order_Approval_Hours

FROM dbo.fact_orders

WHERE approval_timestamp IS NOT NULL;
GO


/*==============================================================================
Q2. How long does it take sellers to dispatch orders?
==============================================================================*/

SELECT

    ROUND
    (
        AVG
        (
            DATEDIFF
            (
                HOUR,
                approval_timestamp,
                carrier_dispatch_timestamp
            )
        ),
        2
    ) AS Average_Dispatch_Hours

FROM dbo.fact_orders

WHERE carrier_dispatch_timestamp IS NOT NULL;
GO


/*==============================================================================
Q3. How long does delivery take after carrier pickup?
==============================================================================*/

SELECT

    ROUND
    (
        AVG
        (
            DATEDIFF
            (
                DAY,
                carrier_dispatch_timestamp,
                delivery_timestamp
            )
        ),
        2
    ) AS Average_Delivery_Days

FROM dbo.fact_orders

WHERE delivery_timestamp IS NOT NULL;
GO


/*==============================================================================
Q4. What is the average end-to-end fulfilment time?
==============================================================================*/

SELECT

    ROUND
    (
        AVG
        (
            DATEDIFF
            (
                DAY,
                purchase_timestamp,
                delivery_timestamp
            )
        ),
        2
    ) AS Average_Fulfilment_Days

FROM dbo.fact_orders

WHERE delivery_timestamp IS NOT NULL;
GO


/*==============================================================================
Q5. Which customer states experience the longest delivery times?
==============================================================================*/

SELECT

    dc.customer_state,

    ROUND
    (
        AVG
        (
            DATEDIFF
            (
                DAY,
                f.purchase_timestamp,
                f.delivery_timestamp
            )
        ),
        2
    ) AS Average_Delivery_Days

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

WHERE f.delivery_timestamp IS NOT NULL

GROUP BY dc.customer_state

ORDER BY Average_Delivery_Days DESC;
GO


/*==============================================================================
Q6. Which sellers deliver the fastest?
==============================================================================*/

SELECT TOP (20)

    ds.seller_id,

    ROUND
    (
        AVG
        (
            DATEDIFF
            (
                DAY,
                f.purchase_timestamp,
                f.delivery_timestamp
            )
        ),
        2
    ) AS Average_Delivery_Days

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

WHERE f.delivery_timestamp IS NOT NULL

GROUP BY ds.seller_id

ORDER BY Average_Delivery_Days ASC;
GO


/*==============================================================================
Q7. How many deliveries were late?
==============================================================================*/

SELECT

    COUNT(*) AS Late_Deliveries

FROM dbo.fact_orders

WHERE delivery_timestamp > estimated_delivery_date;
GO


/*==============================================================================
Q8. How many deliveries arrived on time?
==============================================================================*/

SELECT

    COUNT(*) AS On_Time_Deliveries

FROM dbo.fact_orders

WHERE delivery_timestamp <= estimated_delivery_date;
GO


/*==============================================================================
Q9. What percentage of deliveries were completed on time?
==============================================================================*/

SELECT

    ROUND
    (
        SUM
        (
            CASE
                WHEN delivery_timestamp <= estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        COUNT(*),
        2
    ) AS On_Time_Delivery_Percentage

FROM dbo.fact_orders

WHERE delivery_timestamp IS NOT NULL;
GO


/*==============================================================================
Q10. What is the distribution of order status?
==============================================================================*/

SELECT

    order_status,

    COUNT(*) AS Total_Orders,

    ROUND
    (
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS Percentage

FROM dbo.fact_orders

GROUP BY order_status

ORDER BY Total_Orders DESC;
GO
