from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2, Lambda
from diagrams.aws.network import VPC, InternetGateway, RouteTable, ALB, Route53, NATGateway
from diagrams.aws.database import RDS
from diagrams.aws.storage import S3
from diagrams.aws.security import WAF
from diagrams.aws.management import Cloudwatch, SystemsManager

with Diagram("AWS Cloud Architecture", show=False):
    with Cluster("VPC (10.0.0.0/16)"):
        igw = InternetGateway("Internet Gateway")
        route_table = RouteTable("Route Table (0.0.0.0/0 -> IGW)")

        with Cluster("Public Subnets"):
            pub_subnet_1 = EC2("Public Subnet 1 (10.0.10.0/24, AZ1)")
            pub_subnet_2 = EC2("Public Subnet 2 (10.0.11.0/24, AZ2)")

        with Cluster("Private Subnets"):
            priv_subnet_1 = EC2("Private Subnet 1 (10.0.20.0/24, AZ1)")
            priv_subnet_2 = EC2("Private Subnet 2 (10.0.21.0/24, AZ2)")

        nat_gw = NATGateway("NAT Gateway\nEgress: Elastic IP")

        with Cluster("Security Groups"):
            frontend_sg = WAF("Frontend SG\nIngress: TCP/80, TCP/443 (0.0.0.0/0)\nEgress: All traffic")
            lambda_sg = WAF("Lambda SG\nEgress: All traffic")
            rds_sg = WAF("RDS SG\nIngress: TCP/5432 (Lambda SG, Admin IP)\nEgress: All traffic")

        alb = ALB("ALB\nDNS: <ALB DNS>\nListener: HTTP (80)\nTarget Group: Backend (ECS Tasks)")
        r53 = Route53("Route 53\nHosted Zone: example.com\nDNS Record: A record -> ALB DNS")
        s3 = S3("S3 Bucket\n${environment}-s3-bucket\nVersioning: Enabled\nReplication: us-west-2 -> us-east-2")
        rds = RDS("RDS\nEngine: PostgreSQL\nInstance Class: db.t3.micro\nMulti-AZ: Enabled\nSG: RDS SG")
        lambda_function = Lambda("Lambda\nRuntime: nodejs14.x\nVPC: Private Subnets")
        api_gateway = ALB("API Gateway\nEndpoint: /example\nIntegration: Lambda")
        ssm = SystemsManager("SSM\nManaged Instance\nAccess: SSM Agent")

        igw >> route_table >> [pub_subnet_1, pub_subnet_2]
        route_table >> [priv_subnet_1, priv_subnet_2]

        pub_subnet_1 >> alb
        alb >> r53
        pub_subnet_1 >> nat_gw
        priv_subnet_1 >> nat_gw

        s3 - [pub_subnet_1, priv_subnet_1]
        priv_subnet_1 >> rds

        lambda_sg >> priv_subnet_1
        frontend_sg >> pub_subnet_1
        rds_sg >> rds

        priv_subnet_1 >> lambda_function >> api_gateway
        pub_subnet_1 >> ssm
        priv_subnet_1 >> ssm
