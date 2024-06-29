use EscapeRoom
go
create trigger TR_insert_price_to_orders
on Orders
for insert
as
	begin
		declare @sum int
		declare @basicPrice int
		declare @addPrice int
		declare @room_id int
		declare @order_id int

		set @room_id = (select room_id from inserted)
		set @order_id = (select Order_id from inserted)

		set @basicPrice = (select Basic_price from EscapeRoom where Room_id = @room_id)
		set @addPrice = (select Add_to_price from EscapeRoom where Room_id = @room_id)

		set @sum = (select Number_of_participants from inserted)
		set @sum = @sum * (select case when @sum > 2 then @addPrice else 1 end)
		set @sum = @sum + @basicPrice
		
		update Orders
		set Price = @sum
		where Order_id = @order_id

		insert into Finance(Type_id, Amount) values(2, @sum)

		update EscapeRoom
		set Number_of_orders = case when Number_of_orders is null then 1 else (Number_of_orders + 1) end
		where Room_id = @room_id
	end
go

go
create trigger TR_insert_data_after_AfterComing
on AfterComing
for insert
as
	begin
		declare @guide_id int
		declare @order_id int

		set @guide_id = (select Guide_id from inserted)
		set @order_id = (select Order_id from inserted)

		--insert into salaries
		if((select Guide_id from Salaries where Guide_id = @guide_id) is null)
			insert into Salaries(Guide_id, is_paid, Rooms) values(@guide_id, 'False', 1)
		else
			update Salaries
			set Rooms = case when Rooms is null then 1 else Rooms + 1 end
			where Guide_id = @guide_id

		--insert into EscapeRoom
		declare @room_id int
		set @room_id = (select o.Room_id 
						from AfterComing a inner join Orders o on a.Order_id = o.Order_id
						where a.Order_id = @order_id)

		if((select Mark from EscapeRoom where Room_id = @room_id) is null)
			update EscapeRoom
			set Mark = ((select Mark from inserted) / Number_of_orders)
			where Room_id = @room_id

		else
			update EscapeRoom
			set Mark = (((Mark * (Number_of_orders - 1)) + (select Mark from inserted)) / Number_of_orders)
			where Room_id = @room_id
	end
go

go
CREATE TABLE [dbo].[Orders_Deleted_Log](
	[Order_id] [int] IDENTITY(1,1) NOT NULL,
	[Customer_id] [int] NOT NULL,
	[Order_date] [datetime] NOT NULL,
	[Coming_date] [datetime] NOT NULL,
	[Hour] [varchar](10) NOT NULL,
	[Number_of_participants] [int] NOT NULL,
	[Price] [int] NULL,
	[Room_id] [int] NOT NULL,
	--שדות נוספים לתיעוד הלוג
	deleted_date datetime not null,
	hostname varchar(10) null,
	username varchar(20) null
	)
go

go
create trigger TR_delete_order
on orders
for delete
as
	begin
		insert into Orders_Deleted_Log(Order_id,Customer_id,Order_date, Coming_date,
					Hour, Number_of_participants, Price, Room_id, deleted_date, hostname, username)
		select Order_id,Customer_id,Order_date, Coming_date,
					Hour, Number_of_participants, Price, Room_id, GETDATE(), HOST_NAME(), SUSER_NAME()
		from deleted

		insert into Finance(Type_id, Amount) values(1, (select price from deleted))
	end
go

go
create view V_Salaries_not_paid
as
	select g.Guide_id, g.FirstName + ' ' + g.LastName as name, (s.Rooms * g.Salary_per_room) as salary
	from Guides g inner join Salaries s on s.Guide_id = g.Guide_id
	where s.is_paid = 'False'
go

go
create procedure PR_pay_guides
as
	begin
		declare @balance int
		declare @currGuide int

		set @balance = dbo.FN_Calc_Balance()

		while(@balance > 0 and (select count(*) as c from V_Salaries_not_paid)>0)
		begin
			set @currGuide = (select top 1 Guide_id from V_Salaries_not_paid)
			set @balance = @balance - (select salary from V_Salaries_not_paid where Guide_id = @currGuide)
			
			update Salaries
			set is_paid = 'True'
			where Guide_id = @currGuide

			insert into Finance(Type_id, amount)
				  values(1, (select salary from V_Salaries_not_paid where Guide_id = @currGuide))
		end
	end
go

go
create procedure PR_modify_orders 
@order_id int, @comingDate datetime, @hour varchar(10), @participants int
as
	begin
		begin try
			update orders
			set Coming_date = @comingDate,Hour = @hour,Number_of_participants = @participants
			where Order_id = @order_id
		end try

		begin catch
			print 'some error occured when modifing your order'
		end catch
	end
go

go
create function dbo.FN_Convert_Date(@myDate datetime)
returns varchar(25)
as
	begin
		declare @newDate varchar(25)
		if @myDate is null
			set @newDate = ('no date available')
		else
			set @newDate = (
				convert(varchar(3), DATENAME(WEEKDAY, @myDate)) + '. ' +
				convert(varchar(2), datepart(day, @myDate))+ ' ' + DATENAME(MONTH, @myDate) + 
				' ' + convert(varchar(4), datepart(year, @myDate))
			)
		return(@newDate)
	end
go

go
create function dbo.FN_two_last_orders()
returns table
as
	return(
		select c.*, dbo.FN_Convert_Date(t.Coming_date) as [coming date], t.Hour, e.Room_name 
		from (select *, row_number() over(partition by customer_id order by comingDate)as rowNumber from Orders) as t
			  inner join Customers c on t.Customer_id = c.Customer_id inner join EscapeRoom e on e.Room_id = t.Room_id
		where rowNumber = 1 or rowNumber = 2
		)
go

go
create function dbo.FN_Count_Orders_For_Week()
returns table
as
	return(
		select c.Zone, count(*) as [num of orders] 
		from orders o 
		inner join EscapeRoom e on o.Room_id = e.Room_id 
		inner join Cities c on e.City_id = c.City_id
		where o.Coming_date >= GETDATE() and o.Coming_date <= GETDATE() + 7
		group by c.Zone
	)
go

go
create function dbo.FN_Show_Orders_not_done()
returns table
as
	return(
		select * from Orders
		except
		select * from orders where Coming_date < GETDATE()
	)
go

go
create function dbo.FN_Calc_Balance()
returns int
as
	begin
		declare @sum int
		set @sum = (select sum(case when Type_id = 1 then Amount * -1 else Amount end) from Finance)
		return @sum
	end
go

select * from V_Salaries_not_paid
select dbo.FN_Calc_Balance()
exec PR_pay_guides