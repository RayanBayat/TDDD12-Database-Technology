-- SELECT 
--     name
-- FROM
--     jbemployee;

# Output
/*
name
Ross, Stanley
Ross, Stuart
Edwards, Peter
Thompson, Bob
Smythe, Carol
Hayes, Evelyn
Evans, Michael
Raveen, Lemont
James, Mary
Williams, Judy
Thomas, Tom
Jones, Tim
Bullock, J.D.
Collins, Joanne
Brunet, Paul C.
Schmidt, Herman
Iwano, Masahiro
Smith, Paul
Onstad, Richard
Zugnoni, Arthur A.
Choy, Wanda
Wallace, Maggie J.
Bailey, Chas M.
Bono, Sonny
Schwarz, Jason B.
*/

# Task 1

-- SELECT
-- 	name
-- FROM
-- 	jbdept
-- ORDER BY 
-- 	name;
    
# Output
/*
name
Bargain
Book
Candy
Children's
Children's
Furniture
Giftwrap
Jewelry
Junior Miss
Junior's
Linens
Major Appliances
Men's
Sportswear
Stationary
Toys
Women's
Women's
Women's
*/

# Task 2

-- SELECT 
--     name
-- FROM
--     jbparts
-- WHERE
--     qoh = 0;

# Output 
/*
name
card reader
card punch
paper tape reader
paper tape punch
*/

# Task 3

-- SELECT 
--     name
-- FROM
--     jbemployee
-- WHERE
--     salary <= 10000 AND salary >= 9000;

# Output
/*
name
Edwards, Peter
Smythe, Carol
Williams, Judy
Thomas, Tom
*/

# Task 4

-- SELECT 
--     name, startyear - birthyear AS 'age'
-- FROM
--     jbemployee;

# Output
/*
name 				age
Ross, Stanley 		18
Ross, Stuart 		1
Edwards, Peter 		30
Thompson, Bob 		40
Smythe, Carol 		38
Hayes, Evelyn 		32
Evans, Michael 		22
Raveen, Lemont 		24
James, Mary 		49
Williams, Judy 		34
Thomas, Tom 		21
Jones, Tim 			20
Bullock, J.D. 		0
Collins, Joanne 	21
Brunet, Paul C. 	21
Schmidt, Herman 	20
Iwano, Masahiro 	26
Smith, Paul 		21
Onstad, Richard 	19
Zugnoni, Arthur A. 	21
Choy, Wanda 		23
Wallace, Maggie J. 	19
Bailey, Chas M. 	19
Bono, Sonny 		24
Schwarz, Jason B. 	15
*/

# Task5

-- SELECT 
--     name
-- FROM
--     jbemployee
-- WHERE
--     name LIKE '%son,%';
    
# Output
/*
name
Thompson, Bob
*/

# Task 6

-- SELECT 
--     name
-- FROM
--     jbitem
-- WHERE
--     supplier IN (SELECT 
--             id
--         FROM
--             jbsupplier
--         WHERE
--             name = 'Fisher-Price');

# Output
/*
name
Maze
The 'Feel' Book
Squeeze Ball
*/

# Task 7

-- SELECT
-- 	name
-- FROM
-- 	jbitem
-- WHERE
-- 	supplier = 89;

# Output
/*
name
Maze
The 'Feel' Book
Squeeze Ball
*/

# Task 8

-- SELECT 
--     name
-- FROM
--     jbcity
-- WHERE
--     id IN (SELECT 
--             city
--         FROM
--             jbsupplier);

# Output
/*
name
Amherst
Boston
New York
White Plains
Hickville
Atlanta
Madison
Paxton
Dallas
Denver
Salt Lake City
Los Angeles
San Diego
San Francisco
Seattle
*/

# Task 9

-- SELECT 
--     name, color
-- FROM
--     jbparts
-- WHERE
--     weight >( SELECT 
--             weight
--         FROM
--             jbparts
--         WHERE
--             name = 'card reader');

# Output
/*
name			color
disk drive		black
tape drive		black
line printer	yellow
card punch		gray
*/

# Task 10

-- SELECT 
--     parts_1.name, parts_1.color
-- FROM
--     jbparts AS parts_1,
--     jbparts AS parts_2
-- WHERE
--     parts_1.weight > parts_2.weight
--         AND parts_2.id = 11; 

# Output
/*
name			color
disk drive		black
tape drive		black
line printer	yellow
card punch		gray
*/

# Task 11

-- SELECT 
--     AVG(weight)
-- FROM
--     jbparts
-- WHERE
--     color = 'black';


# Output
/*
AVG(weight)
347.2500
*/

# Task 12

-- SELECT 
--     t1.name AS 'Name', t2.tweight AS 'Total Weight'
-- FROM
--     (SELECT 
--         name, id
--     FROM
--         jbsupplier
--     WHERE
--         city IN (SELECT 
--                 id
--             FROM
--                 jbcity
--             WHERE
--                 state = 'Mass')) AS t1
--         JOIN
--     (SELECT 
--         supplier, SUM(quan * weight) AS tweight
--     FROM
--         jbsupply
--     JOIN jbparts ON jbsupply.part = jbparts.id
--     GROUP BY supplier) AS t2 ON t1.id = t2.supplier;

# Output
/*
Name			Total Weight
Fisher-Price	1135000
DEC 			3120
*/

# Task 13

#DROP TABLE task14;

-- CREATE TABLE task14 (
--     id INT NOT NULL,
--     name VARCHAR(99) NOT NULL,
--     dept INT NOT NULL,
--     price INT NOT NULL,
--     qoh INT NOT NULL,
--     supplier INT NOT NULL,
--     CONSTRAINT pk_task14 PRIMARY KEY (id),
--     CONSTRAINT fk_task14_supp FOREIGN KEY (supplier)
--         REFERENCES jbsupplier (id),
--     CONSTRAINT fk_task14_dept FOREIGN KEY (dept)
--         REFERENCES jbdept (id)
-- );

-- INSERT INTO task14
-- SELECT * 
-- FROM jbitem
-- WHERE price < (SELECT AVG(price) from jbitem);

-- SELECT 
--     *
-- FROM
--     task14;


# Output
/*
id 	name 					dept 	price 	qoh 	supplier
11 	Wash Cloth 				1 		75 		575 	213
19 	Bellbottoms 			43 		450 	600 	33
21 	ABC Blocks 				1 		198 	405 	125
23 	1 lb Box 				10 		215 	100 	42
25 	2 lb Box, Mix 			10 		450 	75 		42
26 	Earrings 				14 		1000 	20 		199
43 	Maze 					49 		325 	200 	89
106 	Clock Book 			49 		198 	150 	125
107 	The 'Feel' Book 	35 		225 	225 	89
118 	Towels, Bath 		26 		250 	1000 	213
119 	Squeeze Ball 		49 		250 	400 	89
120 	Twin Sheet 			26 		800 	750 	213
165 	Jean 				65 		825 	500 	33
258 	Shirt 				58 		650 	1200 	33
*/

# Task 14

-- CREATE OR REPLACE VIEW task15 AS
--     SELECT 
--         name
--     FROM
--         jbitem
--     WHERE
--         price < (SELECT 
--                 AVG(price)
--             FROM
--                 jbitem);

-- SELECT 
--     *
-- FROM
--     task15;

# Output
/*
name
Wash Cloth
Bellbottoms
ABC Blocks
1 lb Box
2 lb Box, Mix
Earrings
Maze
Clock Book
The 'Feel' Book
Towels, Bath
Squeeze Ball
Twin Sheet
Jean
Shirt
*/

# Task 15

/* A wiew is dynamic and a table is static. Static in this context means that the content doesn't change after creation, unless
it's directly altered. The view on the other hand is dynamic since the content can change if the underlying data is altered.
For example if more items are added the view will be uppdated based on the new information.*/

# Task 16

-- CREATE OR REPLACE VIEW task17 AS
--     SELECT 
--         jbsale.debit, SUM(jbitem.price * jbsale.quantity) AS 'Total'
--     FROM
--         jbitem,
--         jbsale
--     WHERE
--         jbsale.item = jbitem.id    #This works just like join
--     GROUP BY jbsale.debit;

-- SELECT 
--     *
-- FROM
--     task17;

# Output
/*
debit 	Total
100581 	2050
100582 	1000
100586 	13446
100592 	650
100593 	430
100594 	3295
*/

# Task 17

-- CREATE OR REPLACE VIEW task18 AS
--     SELECT 
--         debit, SUM(jbitem.price * quantity) AS 'Total'
--     FROM
--         jbsale
--             INNER JOIN
--         jbitem ON jbitem.id = jbsale.item
--     GROUP BY jbsale.debit;
--     
-- SELECT 
--     *
-- FROM
--     task18;

# Output
/*
debit 	Total
100581 	2050
100582 	1000
100586 	13446
100592 	650
100593 	430
100594 	3295
*/

# Task 18

-- DELETE FROM jbsale 
-- WHERE
--     item IN (SELECT 
--         id
--     FROM
--         jbitem
--     
--     WHERE
--         supplier IN (SELECT 
--             id
--         FROM
--             jbsupplier
--         
--         WHERE
--             city IN (SELECT 
--                 id
--             FROM
--                 jbcity
--             
--             WHERE
--                 name = 'Los Angeles')));

-- DELETE FROM jbitem 
-- WHERE
--     supplier IN (SELECT 
--         id
--     FROM
--         jbsupplier
--     
--     WHERE
--         city IN (SELECT 
--             id
--         FROM
--             jbcity
--         
--         WHERE
--             name = 'Los Angeles'));

-- DELETE FROM jbsupplier 
-- WHERE
--     city IN (SELECT 
--         id
--     FROM
--         jbcity
--     
--     WHERE
--         name = 'Los Angeles');

-- SELECT 
--     *
-- FROM
--     jbsupplier;

# Output
/*
id 		name 			city
5 		Amdahl 			921
15 		White Stag 		106
20 		Wormley 		118
33 		Levi-Strauss 	941
42 		Whitman's 		802
62 		Data General 	303
67 		Edger 			841
89 		Fisher-Price 	21
122 	White Paper 	981
125 	Playskool 		752
199 	Koret 			900
213 	Cannon 			303
241 	IBM 			100
440 	Spooley 		609
475 	DEC 			10
999 	A E Neumann 	537
*/

# Task 19a

/* Because in jbsale we have tuples that depends on some tuples in jbitem that depends on some tuples in jbsupplier. 
* we had to to first delete the tuples from jbsale then frpm jbitem then from jbsupplier. 
*/

# Task 19b


-- CREATE OR REPLACE VIEW v1 (supplier , item) AS
--     SELECT 
--         jbsupplier.name, jbitem.name
--     FROM
--         jbsupplier,
--         jbitem
--     WHERE
--         jbsupplier.id = jbitem.supplier;

-- CREATE OR REPLACE VIEW v2 (item , quantity) AS
--     SELECT 
--         jbitem.name, IFNULL(jbsale.quantity, 0)
--     FROM
--         jbitem
--             LEFT JOIN
--         jbsale ON jbitem.id = jbsale.item;

-- CREATE OR REPLACE VIEW jbsale_supply (supplier , quantity) AS
--     SELECT 
--         v1.supplier, SUM(v2.quantity)
--     FROM
--         v1
--             LEFT JOIN
--         v2 ON v1.item = v2.item
--     GROUP BY v1.supplier;

-- SELECT 
--     *
-- FROM
--     jbsale_supply;


# Output
/*
supplier 	quantity
Cannon 			6
Fisher-Price 	0
Koret 			1
Levi-Strauss 	1
Playskool 		2
White Stag 		4
Whitman's 		2
*/

# Task 20



