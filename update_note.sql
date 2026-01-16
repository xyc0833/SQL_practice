use sql_store;

SELECT * from customers;
-- INSERT INTO	 customers
-- values()
INSERT into customers(
	address,
    city,
    state,
    last_name,
    first_name,
    birth_date) 
VALUES(
'5225 Figueroa Mountain Rd',
'Los Olivos',
'CA',
'Jackson',
'michael',
'1958-08-29'
);


INSERT into shippers(name)
values('shipper1'),
	('shipper2'),
    ('shipper3');
    
 insert into products(name,quantity_in_stock,unit_price)
 values('product1',1,10),
 ('product2',2,20),
 ('product3',3,30);
 
 insert into orders(customer_id,order_date,status)
 values(1,'2019-01-01',1);
 select last_insert_id();
 INSERT INTO order_items
 values(last_insert_id(),1,2,2.5),
 (last_insert_id(),2,5,1.5);
 
 create table orders_archived as
	select * from orders
	where order_date<'2019-01-01';
    
drop table orders_archived;
