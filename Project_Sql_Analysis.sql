/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

/*The below query gives us the names of facilities that charge from members:*/
SELECT b.facid, f.name, f.membercost
FROM Bookings b
JOIN Facilities f ON f.facid = b.facid
WHERE f.membercost >0
GROUP BY 1 , 2

/* Q2: How many facilities do not charge a fee to members? */

/*The below query gives us the names of facilities that do not charge from members:*/
SELECT b.facid, f.name, f.membercost
FROM Bookings b
JOIN Facilities f ON f.facid = b.facid
WHERE f.membercost =0
GROUP BY 1 , 2


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT b.facid, f.name, SUM( f.membercost ) member_cost, SUM( f.monthlymaintenance ) maintenance_cost
FROM Facilities f
JOIN Bookings b ON b.facid = f.facid
WHERE f.membercost < 0.2 * f.monthlymaintenance
GROUP BY 1 , 2



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT b.facid, COUNT( b.memid ) no_of_members, SUM( b.slots ) no_of_slots, f.name, SUM( f.membercost ) member_cost, SUM( f.guestcost ) guest_cost, SUM( f.initialoutlay ) initialoutlay, SUM( monthlymaintenance ) monthlymaintenance_cost
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
WHERE f.facid =1
OR 2
GROUP BY 1

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance >100
THEN 'Expensive'
ELSE 'Cheap'
END AS CostofFacility
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname, surname, joindate
FROM Members
WHERE joindate = (
SELECT MAX( joindate )
FROM Members )

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT CONCAT( m.firstname, " ", m.surname ) AS Member_name, f.name court_name
FROM Facilities f
JOIN Bookings b ON b.facid = f.facid
JOIN Members m ON m.memid = b.memid
WHERE f.name = 'Tennis Court 1'
OR 'Tennis Court 2'
ORDER BY 1

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT Facilities.name AS facility, CONCAT( Members.firstname,  ' ', Members.surname ) AS name,
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
AND Bookings.starttime LIKE  '2012-09-14%'
AND (((Bookings.memid =0) AND (Facilities.guestcost * Bookings.slots >30))
OR ((Bookings.memid !=0) AND (Facilities.membercost * Bookings.slots >30)))
INNER JOIN Members ON Bookings.memid = Members.memid
ORDER BY cost DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
select sub.*
from  
(SELECT F.name as Facility,concat(M.firstname, ' ', M.surname) as Name,
CASE WHEN B.memid =0
THEN F.guestcost * B.slots
ELSE F.membercost * B.slots
END AS cost
FROM Bookings B
INNER JOIN Facilities F ON B.facid = F.facid
and ((B.memid =0 and F.guestcost * B.slots > 30) 
or (B.memid !=0 and F.membercost * B.slots > 30))
and B.starttime like '2012-09-14%'
inner join Members M 
on M.memid = B.memid
order by cost desc) sub 

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select sub.name as facility, sum(sub.cost) as revenue
from (
select F.name,
    case when B.memid=0 then F.guestcost*B.slots
    else F.membercost*B.slots end as cost
    from Facilities F
    join Bookings B 
    on B.facid = F.facid
) sub
group by 1
order by 2