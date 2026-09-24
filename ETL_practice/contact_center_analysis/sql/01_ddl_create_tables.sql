CREATE DATABASE ContactsDB
USE ContactsDB

CREATE TABLE stg_support_operations(
    Ticket_ID VARCHAR(100),
    Date_Created DATETIME,
    Agent_ID INT,
    Channel_Type VARCHAR(100),
    Handle_Time_Secs INT,
    Escalated_Flag VARCHAR(100),
    Resolved VARCHAR(100)
);
CREATE TABLE Dim_Agents(
    Agent_ID INT PRIMARY KEY,
    Agent_Name VARCHAR(100),
    Role VARCHAR(100),
    Location VARCHAR(100)
);
CREATE TABLE Dim_Channels(
    Channel_ID INT PRIMARY KEY,
    Channel_Name VARCHAR(100),
    Target_SLA_Secs INT
);
CREATE TABLE Fact_Tickets(
    Ticket_ID VARCHAR(100) PRIMARY KEY,
    Interaction_Date DATE,
    Interaction_Hour INT,
    Agent_ID INT FOREIGN KEY REFERENCES Dim_Agents(Agent_ID),
    Channel_ID INT FOREIGN KEY REFERENCES Dim_Channels(Channel_ID),
    Handle_Time_Secs INT,
    Is_Escalated BIT,
    Is_Resolved BIT
);