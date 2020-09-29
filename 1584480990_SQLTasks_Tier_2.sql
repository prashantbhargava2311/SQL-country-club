/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you:
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1.

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface.
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
ANS:1 SELECT name
FROM Facilities
WHERE membercost > 0;

name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */
SELECT count( * )
FROM Facilities
WHERE membercost = 0

4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance
FROM `Facilities`
WHERE membercost >0
AND (
membercost / monthlymaintenance
) < 0.2;

 facid 	name 	membercost 	monthlymaintenance
0 	Tennis Court 1 	5.0 	200
1 	Tennis Court 2 	5.0 	200
4 	Massage Room 1 	9.9 	3000
5 	Massage Room 2 	9.9 	3000
6 	Squash Court 	  3.5 	80

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT *
FROM `Facilities`
WHERE facid
IN ( 1, 5 );

 facid 	name 	membercost Ascending 	guestcost 	initialoutlay 	monthlymaintenance
1 	Tennis Court 2 	5.0 	25.0 	8000 	                          200
5 	Massage Room 2 	9.9 	80.0 	4000 	                          3000

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, `monthlymaintenance` ,
CASE WHEN `monthlymaintenance` >100
THEN 'expensive'
ELSE 'cheap'
END AS label
FROM Facilities


name 	monthlymaintenance 	label
Tennis Court 1 	200 	expensive
Tennis Court 2 	200 	expensive
Badminton Court 	50 	cheap
Table Tennis 	10 	    cheap
Massage Room 1 	3000 	expensive
Massage Room 2 	3000 	expensive
Squash Court 	80 	    cheap
Snooker Table 	15  	cheap
Pool Table 	15      	cheap

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */


SELECT firstname, surname
FROM Members
WHERE joindate
IN (SELECT max(joindate)
FROM Members
);

firstname 	surname
Darren     Smith

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT (
concat( M.firstname, ' ', M.surname )
) AS Name, F.name AS Facilities
FROM Members AS M
LEFT JOIN Bookings AS B ON M.memid = B.memid
LEFT JOIN Facilities AS F ON F.facid = B.facid
WHERE F.facid
IN ( 0, 1 )
ORDER BY Name

 Name Ascending 	Facilities
Anne Baker 	Tennis Court 2
Anne Baker 	Tennis Court 1
Burton Tracy 	Tennis Court 1
Burton Tracy 	Tennis Court 2
Charles Owen 	Tennis Court 2
Charles Owen 	Tennis Court 1
Darren Smith 	Tennis Court 2
David Farrell 	Tennis Court 2
David Farrell 	Tennis Court 1
David Jones 	Tennis Court 2
David Jones 	Tennis Court 1
David Pinker 	Tennis Court 1
Douglas Jones 	Tennis Court 1
Erica Crumpet 	Tennis Court 1
Florence Bader 	Tennis Court 2
Florence Bader 	Tennis Court 1
Gerald Butters 	Tennis Court 2
Gerald Butters 	Tennis Court 1
GUEST GUEST 	Tennis Court 1
GUEST GUEST 	Tennis Court 2
Henrietta Rumney 	Tennis Court 2
Jack Smith 	Tennis Court 2
Jack Smith 	Tennis Court 1
Janice Joplette 	Tennis Court 1
Janice Joplette 	Tennis Court 2
Jemima Farrell 	Tennis Court 1
Jemima Farrell 	Tennis Court 2
Joan Coplin 	Tennis Court 1
John Hunt 	Tennis Court 2
John Hunt 	Tennis Court 1
Matthew Genting 	Tennis Court 1
Millicent Purview 	Tennis Court 2
Nancy Dare 	Tennis Court 1
Nancy Dare 	Tennis Court 2
Ponder Stibbons 	Tennis Court 1
Ponder Stibbons 	Tennis Court 2
Ramnaresh Sarwin 	Tennis Court 1
Ramnaresh Sarwin 	Tennis Court 2
Tim Boothe 	Tennis Court 2
Tim Boothe 	Tennis Court 1
Tim Rownam 	Tennis Court 1
Tim Rownam 	Tennis Court 2
Timothy Baker 	Tennis Court 2
Timothy Baker 	Tennis Court 1
Tracy Smith 	Tennis Court 1
Tracy Smith 	Tennis Court 2

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT f.name,(m.firstname || m.surname) as User_Name,
CASE WHEN b.facid = 0  THEN (f.guestcost*b.slots)
WHEN b.facid != 0 THEN (f.membercost*b.slots )
END AS cost
FROM bookings AS b
LEFT JOIN facilities f ON b.facid = f.facid
LEFT JOIN members AS m ON b.memid = m.memid
WHERE b.starttime LIKE '2012-09-14%' and cost >30;

name            User_Name   cost
Tennis Court 1	BurtonTracy	75
Tennis Court 1	DavidPinker	75
Tennis Court 1	GeraldButters	75
Tennis Court 1	TimRownam	75
Tennis Court 1	GUESTGUEST	75
Tennis Court 1	DouglasJones	75
Tennis Court 1	GUESTGUEST	75
Massage Room 1	JemimaFarrell	39.6
Massage Room 2	GUESTGUEST	39.6

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT bf.name,(m.firstname || m.surname) as User_Name, bf.cost
from (SELECT b.memid,b.slots,f.name, CASE WHEN b.facid = 0  THEN (f.guestcost*b.slots)
WHEN b.facid != 0 THEN (f.membercost*b.slots)
END AS cost from Bookings as b
LEFT join Facilities as f
ON b.facid=f.facid
WHERE b.starttime LIKE "2012-09-14%") as bf
LEFT JOIN Members as m
on bf.memid=m.memid
WHERE bf.cost>30;

name            User_Name   cost
Tennis Court 1	BurtonTracy	75
Tennis Court 1	DavidPinker	75
Tennis Court 1	GeraldButters	75
Tennis Court 1	TimRownam	75
Tennis Court 1	GUESTGUEST	75
Tennis Court 1	DouglasJones	75
Tennis Court 1	GUESTGUEST	75
Massage Room 1	JemimaFarrell	39.6
Massage Room 2	GUESTGUEST	39.6

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook
for the following questions.

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select name, revenue from (
	select facs.name, sum(case
				when memid = 0 then slots * facs.guestcost
				else slots * membercost
			end) as revenue
		from bookings bks
		inner join facilities facs
			on bks.facid = facs.facid
		group by facs.name
	) as agg where revenue < 1000
order by revenue;


Facilities    revenue
Table Tennis	180
Snooker Table	240
Pool Table	270


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT m2.surname,m2.firstname, m1.surname,m1.firstname
from Members as m1
JOIN Members as m2
on m1.memid=m2.recommendedby
ORDER  by m2.surname, m2.firstname;

Sname  Fname    R_Sname   R_Fname
Bader	Florence	Stibbons	Ponder
Baker	Anne	Stibbons	Ponder
Baker	Timothy	Farrell	Jemima
Boothe	Tim	Rownam	Tim
Butters	Gerald	Smith	Darren
Coplin	Joan	Baker	Timothy
Crumpet	Erica	Smith	Tracy
Dare	Nancy	Joplette	Janice
Genting	Matthew	Butters	Gerald
Hunt	John	Purview	Millicent
Jones	David	Joplette	Janice
Jones	Douglas	Jones	David
Joplette	Janice	Smith	Darren
Mackenzie	Anna	Smith	Darren
Owen	Charles	Smith	Darren
Pinker	David	Farrell	Jemima
Purview	Millicent	Smith	Tracy
Rumney	Henrietta	Genting	Matthew
Sarwin	Ramnaresh	Bader	Florence
Smith	Jack	Smith	Darren
Stibbons	Ponder	Tracy	Burton
Worthington-Smyth	Henry	Smith	Tracy

/* Q12: Find the facilities with their usage by member, but not guests */

SELECT strftime('%m', starttime) as Month,count(memid) as Count_memid, memid
from Bookings
GROUP by Month, memid;

month Count_memid    memid
07	178	             0
07	100	             1
07	83	             2
07	132	             3
07	63	             4
07	50	             5
07	18	             6
07	18	             7
07	16	             8
08	304              0
08	94	             1
08	77	             2
08	153	             3
08	56	             4
08	64	             5
08	111	             6
08	57	             7
08	103	             8
08	54	             9
08	69	             10
08	56	             11
08	52	             12
08	37	             13
08	43	             14
08	39	             15
08	62	             16
08	23	             17
08	10	             20
08	8	               21
09	401	              0
09	67	              1
09	50	              2
09	123	              3
09	40	              4
09	49	              5
09	47	              6
09	42	              7
09	69	              8
09	50	              9
09	62	              10
09	59	              11
09	66	              12
09	43	              13
09	46	              14
09	81	              15
09	104	              16
09	48	              17
09	62	              20
09	118	              21
09	53	              22
09	70	              24
09	14	              26
09	20	              27
09	34	              28
09	41	              29
09	16	              30
09	16	              33
09	15	              35
09	7	                36

/* Q13: Find the facilities usage by month, but not guests */
SELECT strftime('%m', starttime) as Month,count(facid) as Count_facid, facid
from Bookings
GROUP by Month, facid;

Month Count_facid facid
07	  88	        0
07	  68	        1
07	  56	        2
07	  51	        3
07	 123	        4
07	  12	        5
07	  75	        6
07	  75	        7
07	 110	        8
08	 146	        0
08	 149	        1
08	 146	        2
08	 147	        3
08	 224	        4
08	  40	        5
08	 170	        6
08	 159	        7
08	 291	        8
09	 174	        0
09	 172	        1
09	 181	        2
09	 205	        3
09	 282	        4
09	  59	        5
09	 195	        6
09	 210	        7
09	 435	        8
