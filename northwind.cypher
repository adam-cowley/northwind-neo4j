// Create customers
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/customers.csv" AS row
CREATE (:Customer {companyName: row.companyName, customerID: row.customerID, fax: row.fax, phone: row.phone});

// Create products
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/products.csv" AS row
CREATE (:Product {productName: row.productName, productID: row.productID, unitPrice: toFloat(row.UnitPrice)});

// Create suppliers
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/suppliers.csv" AS row
CREATE (:Supplier {companyName: row.companyName, supplierID: row.supplierID});

// Create employees
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/employees.csv" AS row
CREATE (:Employee {employeeID:row.employeeID,  firstName: row.firstName, lastName: row.lastName, title: row.title});

// Create categories
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/categories.csv" AS row
CREATE (:Category {categoryID: row.categoryID, categoryName: row.categoryName, description: row.description});

// Create Orders
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/orders.csv" AS row
MERGE (order:Order {orderID: row.orderID}) ON CREATE SET order.shipName =  row.shipName;

// Add indexes
CREATE INDEX ON :Product(productID);
CREATE INDEX ON :Product(productName);
CREATE INDEX ON :Category(categoryID);
CREATE INDEX ON :Employee(employeeID);
CREATE INDEX ON :Supplier(supplierID);
CREATE INDEX ON :Customer(customerID);
CREATE INDEX ON :Customer(customerName);

// Relate orders to products
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/order-details.csv" AS row
MATCH (order:Order {orderID: row.orderID})
MATCH (product:Product {productID: row.productID})
MERGE (order)-[pu:PRODUCT]->(product)
ON CREATE SET pu.unitPrice = toFloat(row.unitPrice), pu.quantity = toFloat(row.quantity);

// Relate Orders to Employees
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/orders.csv" AS row
MATCH (order:Order {orderID: row.orderID})
MATCH (employee:Employee {employeeID: row.employeeID})
MERGE (employee)-[:SOLD]->(order);

// Relate customers to orders
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/orders.csv" AS row
MATCH (order:Order {orderID: row.orderID})
MATCH (customer:Customer {customerID: row.customerID})
MERGE (customer)-[:PURCHASED]->(order);

// Relate Products to suppliers
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/products.csv" AS row
MATCH (product:Product {productID: row.productID})
MATCH (supplier:Supplier {supplierID: row.supplierID})
MERGE (supplier)-[:SUPPLIES]->(product);


// Relate Products to Categories
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/products.csv" AS row
MATCH (product:Product {productID: row.productID})
MATCH (category:Category {categoryID: row.categoryID})
MERGE (product)-[:PART_OF]->(category);

// Relate employees to managers
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/employees.csv" AS row
MATCH (employee:Employee {employeeID: row.employeeID})
MATCH (manager:Employee {employeeID: row.reportsTo})
MERGE (employee)-[:REPORTS_TO]->(manager);


CREATE CONSTRAINT ON (o:Order) ASSERT o.orderID IS UNIQUE;



// Add unit price
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Users/adam/projects/northwind-neo4j/data/order-details.csv" AS row
MATCH (product:Product {productID: row.productID})
MERGE (order)-[pu:PRODUCT]->(product)
ON CREATE SET pu.unitPrice = toFloat(row.unitPrice), pu.quantity = toFloat(row.quantity);