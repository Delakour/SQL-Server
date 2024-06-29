insert into TypeFinance(Type_name) values('�����')
insert into TypeFinance(Type_name) values('�����')

insert into Guides(FirstName, LastName, Phone, Address, Salary_per_room) values('Itsik', 'Lev', '055-6771535', '����� 43', 45)
insert into Guides(FirstName, LastName, Phone, Address, Salary_per_room) values('Eli', 'Hadar', '053-4102139', '�� ���� 5', 37)
insert into Guides(FirstName, LastName, Phone, Address, Salary_per_room) values('Yossi', 'Kahan', '054-4508552', '���� 16', 41)
insert into Guides(FirstName, LastName, Phone, Address, Salary_per_room) values('Lev', 'Rachamim', '054-5474834', '������� 7', 39)

insert into Cities(City_name, Zone) values('�������', '����')
insert into Cities(City_name, Zone) values('�� ����', '����')
insert into Cities(City_name, Zone) values('�����', '����')
insert into Cities(City_name, Zone) values('����', '����')
insert into Cities(City_name, Zone) values('��� ���', '����')
insert into Cities(City_name, Zone) values('����� �����', '����')

insert into Customers(FirstName, LastName, Email, Phone) values('�����', '�����', 'aaroungar@gmail.com', '054-8590173')
insert into Customers(FirstName, LastName, Email, Phone) values('����', '���', 'simi2000@gmail.com', '052-7168667')
insert into Customers(FirstName, LastName, Email, Phone) values('����', '����', 'Roz1234@gmail.com', '054-8562208')
insert into Customers(FirstName, LastName, Email, Phone) values('����', '������', 'ShoshRapa@gmail.com', '054-8562626')

insert into EscapeRoom(Room_name, Address, City_id, Time, Scary, Hard, Basic_price, Add_to_price)
			values('����� �����', '���� ������ ����� 4', 1, '1:00', 2, 34.55, 150, 50)
insert into EscapeRoom(Room_name, Address, City_id, Time, Scary, Hard, Basic_price, Add_to_price)
			values('������ �����', '���� ��� ���� ����� 34', 5, '1:30', 3, 64.00, 220, 80)
insert into EscapeRoom(Room_name, Address, City_id, Time, Scary, Hard, Basic_price, Add_to_price)
			values('������ ������', '���� ������! 13', 2, '1:15', 1, 2, 120, 74)
insert into EscapeRoom(Room_name, Address, City_id, Time, Scary, Hard, Basic_price, Add_to_price)
			values('����� ����', '���� �� ����... 67', 3, '2:00', 0, 1, 180, 35)

insert into Orders(Customer_id, Order_date, Coming_date, Hour, Number_of_participants, Room_id)
			values(3, GETDATE()-13, GETDATE() + 4, '16:30', 5, 2)

insert into Orders(Customer_id, Order_date, Coming_date, Hour, Number_of_participants, Room_id)
			values(3, GETDATE()-20, GETDATE() + 10, '17:20', 3, 1)

insert into Orders(Customer_id, Order_date, Coming_date, Hour, Number_of_participants, Room_id)
			values(2, GETDATE()-4, GETDATE(), '17:00', 4, 4)

insert into Orders(Customer_id, Order_date, Coming_date, Hour, Number_of_participants, Room_id)
			values(4, GETDATE()-3, GETDATE() - 2, '14:30', 3, 2)

insert into AfterComing(Order_id, Mark, Guide_id) values(1, 9.6, 3)
