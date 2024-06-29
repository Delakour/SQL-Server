create database EscapeRoom collate hebrew_100_ci_as

create table Customers(
Customer_id int identity not null,
FirstName varchar(100) not null,
LastName varchar(100) null,
Email varchar(100) not null,
Phone varchar(15) not null
constraint PK_Customers#Customer_id primary key(Customer_id)
)

create table Cities(
City_id int identity not null,
City_name varchar(100) not null,
Zone varchar(30) not null
constraint PK_Cities#City_id primary key(City_id)
)

create table EscapeRoom(
Room_id int identity not null,
Room_name varchar(100) not null,
Address varchar(100) not null,
City_id int not null,
Time varchar(10) not null,
Scary int null,
Hard int not null,
Mark numeric(7, 2) null,
Basic_price int not null,
Add_to_price int not null,
Number_of_orders int null
constraint PK_EscapeRoom#Room_id primary key(Room_id)
constraint FK_Cities_EscapeRoom foreign key(City_id) references Cities(City_id)
)

create table Guides(
Guide_id int identity not null,
FirstName varchar(100) not null,
LastName varchar(100) not null,
Phone varchar(15) not null,
Address varchar(100) not null,
Salary_per_room int not null
constraint PK_Guides#Guide_id primary key(Guide_id)
)

create table Salaries(
id int identity not null,
Guide_id int not null,
Rooms int null,
is_paid bit not null
constraint FK_Guides_Salaries foreign key(Guide_id) references Guides(Guide_id)
)

create table Orders(
Order_id int identity not null,
Customer_id int not null,
Order_date datetime not null,
Coming_date datetime not null,
Hour varchar(10) not null,
Number_of_participants int not null,
Price int null,
Room_id int not null
constraint PK_Orders#Order_id primary key(Order_id),
constraint FK_Customers_Orders foreign key(Customer_id) references Customers(Customer_id),
constraint FK_EscapeRoom_Orders foreign key(Room_id) references EscapeRoom(Room_id)
)

create table AfterComing(
id int identity not null,
Order_id int not null,
Guide_id int not null,
Mark numeric(7, 2) null,
description varchar(100) null
constraint FK_Guides_AfterComing foreign key(Guide_id) references Guides(Guide_id),
constraint FK_Orders_AfterComing foreign key(Order_id) references Orders(Order_id)
)

create table TypeFinance(
Type_id int identity not null,
Type_name varchar(30) not null
constraint PK_TypeFinance#Type_id primary key(Type_id)
)

create table Finance(
Finance_id int identity not null,
Type_id int not null,
Amount int not null
constraint PK_Finance#Finance_id primary key(Finance_id)
constraint FK_TypeFinance_Finance foreign key(Type_id) references TypeFinance(Type_id)
)