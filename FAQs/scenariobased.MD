1)	How can you make your application scalable for a big traffic day?
Keep the EC2 instances in autoscaling group and use load balancer. The burst will be high during big traffic day so we need to pre-warm load balancers. Utilize scheduled scaling will have multiple EC2 instances to handle huge traffic. 
If application is connecting to Database, then will make use of Database proxy(Eg.RDS Proxy). Will reuse the orphan connection to the DB or will terminate as necessarily. 
Run IEM(Infrastructure Event Management) to ensure it can handle high traffic. 
Increase Account Limits. Utilize different (Account + Region) combo. Need to request AWS to increase certain limits. 
Database Proxy: Amazon RDS Proxy is a fully managed, highly available database proxy for Amazon Relational Database Service (RDS) that makes applications more scalable, more resilient to database failures, and more secure.
Many applications, including those built on modern serverless architectures, can have a large number of open connections to the database server and may open and close database connections at a high rate, exhausting database memory and compute resources. Amazon RDS Proxy allows applications to pool and share connections established with the database, improving database efficiency and application scalability. With RDS Proxy, failover times for Aurora and RDS databases are reduced by up to 66% and database credentials, authentication, and access can be managed through integration with AWS Secrets Manager and AWS Identity and Access Management (IAM).
AWS IEM: AWS Infrastructure Event Management (IEM) offers architecture and scaling guidance and operational support during the preparation and execution of planned events, such as shopping holidays, product launches, and migrations. For these events, AWS Infrastructure Event Management will help you assess operational readiness, identify and mitigate risks, and execute your event confidently with AWS experts by your side. The program is included in the Enterprise Support plan and is available to Business Support customers for an additional fee.

Serverless Scaling:
Ensure Provisioned Concurrency is enabled. It will prewarm certain number of lambdas. It can be done in autoscaling way or in scheduled manner.
Optimize lambda code using X-ray
Optimize Lambda configuration using Cloud watch insights
For API Gateway, enable API Caching, Use HTTP API instead of REST API, HTTP API is faster and cheaper. 
Increase Account Limits. Utilize different (Account + Region) combo. Need to request AWS to increase certain limits. 
API Caching: Amazon API Gateway throttles requests to your API to prevent it from being overwhelmed by too many requests. Turn on API caching to reduce the number of calls made to your endpoint.

There are multiple API Gateway Cache sizes available. To select the appropriate cache size, run a load test on your API and then review the Amazon CloudWatch metrics.

Container Scaling: 
User Horizontal Pod Autoscaler, Cluster Autoscaler, and replicaset. 
Use replicaset to run multiple copies of pod
Use Cluster overprovisioner to provision nodes
The burst will be high during big traffic day so we need to pre-warm load balancers.
Use Database proxy inbetween pods and Database
Increase Account Limits. Utilize different (Account + Region) combo. Need to request AWS to increase certain limits. 
2)	Synchronous vs Event Driven Architecture: 
Synchronous Architecture: 
All components of Syncrhronous architectures must scale together i.e if Amazon API Gateway scales, then AWS Lambda scales and Amazon DynamoDB scales. 
Consumer needs to resend transaction for re-processing, and it is expensive. 
Event Driven/Assynchronous Architecture: 
We decouple the components using buffering messages. 
So here instead of API Gateway directly sending the request to Lambda we use Amazon Simple Queue Service in between. API Gateway will send messages to SQS so we can control the rate of consumption of Lambda. 
Advantages: 
Each component can scale independently
Retry built in, Cost effective than synchronous architecture
Example Ordering system:
Order inserts can be done event-driven
Order status retrieval synchronously
3)	Queue vs Pubsub
Queue: We have only one consumer in Queue, consumer is pulling the messages from the queue. One the message is processed then message will be deleted. There can be multiple consumers.  Ex: Amazon SQS, Amazon MQ
Pubsub: In Pubsub, the system will publish a message to a topic, we can have multiple consumers. It is a push model. As soon as message gets published to this topic, the message gets pushed to all the subscribers of the topic. Ex: Amazon SNS and Event Bridge
Streaming: Ex: Kinesis and MSK(Amazon Message Streaming for Kafka)
Event Bridge: EventBridge is a serverless service that uses events to connect application components together, making it easier for you to build scalable event-driven applications. Use it to route events from sources such as home-grown applications, AWS services, and third- party software to consumer applications across your organization. EventBridge provides a simple and consistent way to ingest, filter, transform, and deliver events so you can build new applications quickly.
4)	SQL vs NoSQL
              
SQL Database (RDBMS)	NOSQL Database
Tables have predefines schema	Schemaless
Holds structured data	Holds structured and unstructured data
Good fit for joins and complex queries	Generally, not good fit for complex multi table queries
Emphasizes on ACID properties(Atomicity, Consistency, Isolation and Durability)	Follow Brewers CAP theorem(Consistency, Availability, and Partition tolerance)
Generally, scales vertically	Generally, scales horizontally. AWS DynamoDB scales automatically
Example: Oracle, DB2, Amazon Aurora, AWS RDS	Example: AWS Dynamo DB, Mongo DB, Cassandra

Amazon Aurora	Amazon Dynamo DB
MySQL and PostgresSQL compatible relational database built for the cloud. 5 times faster than standard MySQL, 3 times faster than standard PostgresSQL at 1/10th the cost	Key-value and document database with single-digit millisecond performance AT ANY SCALE
Multi-Master supported for MySQL	Multi-Master
Cross region Active-Passive replication supported for MySQL (Global Database - Designed for globally distributed applications)	Cross region Active-Active replication supported (Global Tables)
Choosing Multi-AZ & Read Replicas provide High Availability	Inherently replicates across three Azs - HA and Durable
Vertical scaling. Serverless Aurora scales automatically, not as scalable as Dynamo	Inherently Scalable, can handle more than 10 trillion requests/day & peaks of more than 20 million requests/second
Has integrated caches, can't be adjusted	Provides adjustable in-memory caching via DAX
Enable backups, snapshots for DB	Inherently durable, Point in Time Backups can be enabled




5)	WebScoket:
Generally, the communication channel is invoked by Client. If Server wants to communicate/send message to client then we make use of WebSocket. In this, Connection stays open, Server can send messages to client and can be achieved using Load Balancer and API Gateway. Usecases: Whatsapp, chatbots, telegram etc
6)	Caching:
Use managed caching of the service
If service doesn’t provide caching then use cache database, the most popular caching databases are Amazon Elastic Cache. Elastic cache for Redis and Elastic cache for Memcached
We can enable caching for API Gateway i.e we need to enable API cache, in Dynamo DB we can enable Dynamo Cache(DAX), in CloudFront we can enable Cache
If we want to cache backend, then we can use Amazon Elastic Cache
Amazon ElastiCache is a fully managed, in-memory caching service supporting flexible, real-time use cases. You can use ElastiCache for caching, which accelerates application and database performance, or as a primary data store for use cases that don't require durability like session stores, gaming leaderboards, streaming, and analytics. ElastiCache is compatible with Redis and Memcached.
Redis vs Memcached:
Amazon ElastiCache for Redis is a great choice for real-time transactional and analytical processing use cases such as caching, chat/messaging, gaming leaderboards, geospatial,   machine learning, media streaming, queues, real-time analytics, and session store.
Amazon ElastiCache for Memcached is a Memcached-compatible, in-memory, key-value store service that can be used as a cache or a data store. It delivers the performance, ease-of-use, and simplicity of Memcached. ElastiCache for Memcached is fully managed, scalable, and secure - making it an ideal candidate for use cases where frequently accessed data must be in-memory. It is a popular choice for use cases such as web, mobile apps, gaming, ad-tech, and e-commerce.
Lazy Loading: 
Amazon ElastiCache is an in-memory key-value store that sits between your application and the data store (database) that it accesses. Whenever your application requests data, it first makes the request to the ElastiCache cache. If the data exists in the cache and is current, ElastiCache returns the data to your application. If the data doesn't exist in the cache or has expired, your application requests the data from your data store. Your data store then returns the data to your application. Your application next writes the data received from the store to the cache. This way, it can be more quickly retrieved the next time it's requested.
Write-through:
The write-through strategy adds data or updates data in the cache whenever data is written to the database.
Adding TTL: Lazy loading allows for stale data but doesn't fail with empty nodes. Write-through ensures that data is always fresh, but can fail with empty nodes and can populate the cache with superfluous data. By adding a time to live (TTL) value to each write, you can have the advantages of each strategy.
7)	Database Sharding(Horizontal Partitioning):
Database sharding is the process of storing a large database across multiple machines. A single machine, or database server, can store and process only a limited amount of data. Database sharding overcomes this limitation by splitting data into smaller chunks, called shards, and storing them across several database servers. All database servers usually have the same underlying technologies, and they work together to store and process large volumes of data.
Benefits of Sharding:
-	Improve response time
-	Avoid total service outage
-	Scale efficiently
Different methods of Database Sharding:
-	Range-based sharding
-	Hashed sharding: Hashed sharding assigns the shard key to each row of the database by using a mathematical formula called a hash function. The hash function takes the information from the row and produces a hash value. The application uses the hash value as a shard key and stores the information in the corresponding physical shard.
-	Directory sharding: Directory sharding uses a lookup table to match database information to the corresponding physical shard. A lookup table is like a table on a spreadsheet that links a database column to a shard key.
-	Geo sharding
Alternatives to Database Sharding:
-	Vertical scaling
-	Replication
-	Partitioning
       How to Optimize Database Sharding:
-	Cardinality: Cardinality describes the possible values of the shard key. It determines the maximum number of possible shards on separate column-oriented databases. For example, if the database designer chooses a yes/no data field as a shard key, the number of shards is restricted to two.
-	Frequency: Frequency is the probability of storing specific information in a particular shard. For example, a database designer chooses age as a shard key for a fitness website. Most of the records might go into nodes for subscribers aged 30–45 and result in database hotspots.
-	Monotonic change: Monotonic change is the rate of change of the shard key. A monotonically increasing or decreasing shard key results in unbalanced shards.
     Challenges of Database Sharding: 
-	Data hotspots: Some of the shards become unbalanced due to the uneven distribution of data. For example, a single physical shard that contains customer names starting with A receives more data than others. This physical shard will use more computing resources than others.
Solution:
You can distribute data evenly by using optimal shard keys. Some datasets are better suited for sharding than others.
-	Operational Complexity: Database sharding creates operational complexity. Instead of managing a single database, developers have to manage multiple database nodes. When they are retrieving information, developers must query several shards and combine the pieces of information together. These retrieval operations can complicate analytics.
Solution:
In the AWS database portfolio, database setup and operations have been automated to a large extent. This makes working with a sharded database architecture a more streamlined task.
-	Infrastructure cost
-	Application complexity

8)	Disaster Recover: 

Resiliency can be defined in terms of metrics called RTO (Recovery Time Objective) and RPO (Recovery Point Objective). RTO is a measure of how quickly can your application recover after an outage and RPO is a measure of the maximum amount of data loss that your application can tolerate.

Disaster Recovery Options: 
 

9)	CAP Theorem:
Consistency: Every reach received the most recent write or an error
Availability: Every request receives a (non-error) response, without the guarantee that it contains the most recent write
Partition Tolerance: The system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes. 

10)	AWS Well Architected Framework:
-	Operational Excellence Pillar:
i)	Perform operations as code
ii)	Make frequent, small, reversible changes
iii)	Refine operations procedures frequently
iv)	Anticipate failure
v)	Learn from all operational failures 
-	Security Pillar:
i)	Implement a strong identity foundation
ii)	Enable Traceability
iii)	Apply security at all layers
iv)	Automate security best practices
v)	Protect data in transit and at rest
vi)	Prepare for a security event
-	Reliability Pillar:
i)	Test Recovery processes
ii)	Automate recovery from failure
iii)	Scale horizontally to increase aggregate system availability
iv)	Stop guessing capacity
v)	Manage change automatically
-	Performance Efficiency Pillar:
i)	Democratize advanced technologies
ii)	Go global in minutes
iii)	Use serverless architectures
iv)	Experiment more often
v)	Mechanical sympathy
-	Cost Optimization Pillar:
i)	Adopt a consumption model
ii)	Measure overall efficiency
iii)	Analyze and attribute expenditure
iv)	Use managed services to reduce cost of ownership
-	Sustainability Pillar
11)	API Gateway:
Deployment types:
-	Edge-optimized – Reduced latency for requests around the world
-	Regional endpoint- Reduced latency for requests that originate in the same region, can also configure your own CDN and protect with WAF
-	Private endpoint – Securely expose your REST APIs only to other services within your VPC or connect via Direct Connect
API Gateway Caching: 
-	You can add caching to API calls by provisioning and Amazon API Gateway cache and specify its size in gigabytes
-	Caching allows you to cache the endpoint’s response
-	Caching can reduce number of calls to the backend and improve latency of requests to the API
API Gateway Throttling:
-	API Gateway sets a limit on a steady-state rate and a burst of request submissions against all APIs in your account
-	Limits:
(1)	By default API Gateway limits the steady-state request rate to 10,000 requests per second
(2)	The maximum concurrent requests is 5,000 requests across all APIs within an AWS account
(3)	If you go over 10,000 requests per second or 5,000 concurrent requests you will receive a 429 Too Many Requests error response
-	Upon catching such exceptions, the client can resubmit the failed requests in a way that is rate limiting, while complying with the API Gateway throttling limits
API Gateway Usage Plans and API Keys:
Usage plans: Basic users, Premium users
Users connect to specific public endpoint with API key that is configured in a usage plan
12)	API Gateway vs Application Load Balancer: 
API Gateway	ALB
Can implement rate limiting, bursting for APIs	No rate limiting, bursting capability
Integrate with AWS WAF for protection	Integrate with AWS WAF for protection
Not possible to get static IP address for endpoint	Possible to get status IP address for load balancer endpoint
Accepts HTTPS traffic	Accepts HTTP, HTTPS traffic
Able to do request validation, request/response mapping	Not able to do request validation, request/response mapping
Able to handle spiky traffic(default rate 10k rps, 5k burst rate)	Delay during spiky traffic, pre-allocate LCUs to avoid delay(charged extra)
Able to integrate with Lambda from different region, even different AWS account	ALB is a regional service
Able to export/import APIs cross API platforms using swagger, Open API Spec 3.0	No direct method to import/export rules for cross platform
Have extensive Authentication & Authorization integration - API key, IAM, Cognito User Pool, Cognito Identity Pool, external IdP	Integration with any OIDC compliant IdP(Cognito, LDAP etc.)
Able to cache responses	Not able to cache responses
Timeout limit is 30seconds	Timeout limit is 4000 seconds
Integrates with almost all AWS services	Use EC2, Lambda, IP addresses as backend
No health check available	Health check available
Serverless service - pay per use	Pay for idle

13)	Data Analytics:
 
•	Amazon Kinesis data stream:

Amazon Kinesis Data Streams is a serverless streaming data service that makes it easy to capture, process, and store data streams at any scale.
 
Use Cases:
Stream log and event data
Run real-time analytics
Power event-driven applications
•	Amazon Kinesis Data Firehose:

Amazon Kinesis Data Firehose is an extract, transform, and load (ETL) service that reliably captures, transforms, and delivers streaming data to data lakes, data stores, and analytics services.
 

Use Cases:
Stream into data lakes and warehouses
Boost security
Build ML streaming applications

•	AWS Glue: 
AWS Glue is a serverless data integration service that makes it easier to discover, prepare, move, and integrate data from multiple sources for analytics, machine learning (ML), and application development.
i)	Data integration engine options: 
Choose your preferred data integration engine in AWS Glue to support your users and workloads.
 
ii)	Event-driven ETL: 
AWS Glue can run your extract, transform, and load (ETL) jobs as new data arrives. For example, you can configure AWS Glue to initiate your ETL jobs to run as soon as new data becomes available in Amazon Simple Storage Service (S3).

iii)	AWS Glue Data Catalog:
You can use the Data Catalog to quickly discover and search multiple AWS datasets without moving the data. Once the data is cataloged, it is immediately available for search and query using Amazon Athena, Amazon EMR, and Amazon Redshift Spectrum.
  




iv)	Nocode ETL jobs:
AWS Glue Studio makes it easier to visually create, run, and monitor AWS Glue ETL jobs. You can build ETL jobs that move and transform data using a drag-and-drop editor, and AWS Glue automatically generates the code.

 
v)	Manage and monitor data quality:
AWS Glue Data Quality automates data quality rule creation, management, and monitoring to help ensure high quality data across your data lakes and pipelines.

 

vi)	AWS Glue DataBrew:

With AWS Glue DataBrew, you can explore and experiment with data directly from your data lake, data warehouses, and databases, including Amazon S3, Amazon Redshift, AWS Lake Formation, Amazon Aurora, and Amazon Relational Database Service (RDS). You can choose from over 250 prebuilt transformations in DataBrew to automate data preparation tasks such as filtering anomalies, standardizing formats, and correcting invalid values.
AWS Glue crawlers and classifiers:

AWS Glue also lets you set up crawlers that can scan data in all kinds of repositories, classify it, extract schema information from it, and store the metadata automatically in the AWS Glue Data Catalog. The AWS Glue Data Catalog can then be used to guide ETL operations.

AWS Glue ETL operations:
Using the metadata in the Data Catalog, AWS Glue can automatically generate Scala or PySpark (the Python API for Apache Spark) scripts with AWS Glue extensions that you can use and modify to perform various ETL operations. For example, you can extract, clean, and transform raw data, and then store the result in a different repository, where it can be queried and analyzed. Such a script might convert a CSV file into a relational form and save it in Amazon Redshift.

Streaming ETL in AWS Glue:
AWS Glue enables you to perform ETL operations on streaming data using continuously-running jobs. AWS Glue streaming ETL is built on the Apache Spark Structured Streaming engine, and can ingest streams from Amazon Kinesis Data Streams, Apache Kafka, and Amazon Managed Streaming for Apache Kafka (Amazon MSK). Streaming ETL can clean and transform streaming data and load it into Amazon S3 or JDBC data stores. Use Streaming ETL in AWS Glue to process event data like IoT streams, clickstreams, and network logs.

The AWS Glue jobs system:
The AWS Glue Jobs system provides managed infrastructure to orchestrate your ETL workflow. You can create jobs in AWS Glue that automate the scripts you use to extract, transform, and transfer data to different locations. Jobs can be scheduled and chained, or they can be triggered by events such as the arrival of new data.
•	Amazon Athena: 
Amazon Athena is a serverless, interactive analytics service built on open-source frameworks, supporting open-table and file formats. Athena provides a simplified, flexible way to analyze petabytes of data where it lives. Analyze data or build applications from an Amazon Simple Storage Service (S3) data lake and 25-plus data sources, including on-premises data sources or other cloud systems using SQL or Python. Athena is built on open-source Trino and Presto engines and Apache Spark frameworks, with no provisioning or configuration effort required.
Use Cases:
Run federated queries: 
Submit a single SQL query to analyze data in relational, nonrelational, object, and custom data sources running on premises or in the cloud.
Prepare data for ML models:
Use ML models in SQL queries or Python to simplify complex tasks, such as anomaly detection, customer cohort analysis, and sales predictions.
Build distributed big data reconciliation engines:
Deploy a reconciliation tool with an engine built for the cloud to validate vast amounts of data effectively at scale.
Analyze Google Analytics data:
Extract Google Analytics data using Amazon AppFlow, store it in Amazon S3, and then query it.
-	Amazon EMR: 
Amazon EMR is the industry-leading cloud big data solution for petabyte-scale data processing, interactive analytics, and machine learning using open-source frameworks such as Apache Spark, Apache Hive, and Presto.

Use Cases:
Perform big data analytics
Run large-scale data processing and what-if analysis using statistical algorithms and predictive models to uncover hidden patterns, correlations, market trends, and customer preferences.
Build scalable data pipelines
Extract data from a variety of sources, process it at scale, and make it available for applications and users.
Process real-time data streams
Analyze events from streaming data sources in real-time to create long-running, highly available, and fault-tolerant streaming data pipelines.
Accelerate data science and ML adoption
Analyze data using open-source ML frameworks such as Apache Spark MLlib, TensorFlow, and Apache MXNet. Connect to Amazon SageMaker Studio for large-scale model training, analysis, and reporting.

Different Architectures:
 
 
 


 

 

14)	Tackling any Tuning/Troubleshooting:
-	Monitor
1.	Logs
2.	Metrics
3.	Traces
-	Measure
1.	Define KPI
2.	Send alarms
-	Remediate
1.	Configuration
2.	Code
                X-Ray: 
                 AWS X-Ray provides a complete view of requests as they travel through your application and filters visual data across payloads, functions, traces, services, APIs, and more with no-code and low-code motions.
 
    Usecases:
1.	Analyze and debug applications
Receive trace data from your simple and complex applications, whether they are in development or production.
2.	Generate a detailed service map
Compile data from your AWS resources to determine bottlenecks in your cloud architecture and improve application performance
3.	View performance analytics
Compare trace sets with different conditions for root cause analysis purposes.
4.	Audit your data securely
Configure X-Ray to meet your security and compliance objectives.

Elemental Media Convert
Amazon Rekognition
HLS format
Security at rest
Security in transit
