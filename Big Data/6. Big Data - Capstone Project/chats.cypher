:history

match (u)-[:CreateChat]->(c)
where c.id in [7803, 7816, 8044, 8194, 9435, 9744, 11312, 13704, 16478, 52694]
return distinct(u.id);

match (u)-[:CreateChat]->(c)
where c.id in [7803, 7816, 8044, 8194,, 9435, 9744, 11312, 13704, 16478, 52694]
return distinct(u.id);

match (u1)-[:CreateChat]->(i)-[:Mentioned]->(u2)
where u1 <> u2
create (u1)-[:InteractsWith]->(u2);

match (u) -[:CreatesSession]-> (c) -[:OwnedBy]-> (t)
where u.id in [394, 2067, 209, 1087, 554, 516, 1627, 999, 461, 668] and t.id in [82, 185, 112, 18, 194, 129, 52, 136, 146, 81]
return u.id, t.id;

MATCH (n) RETURN n LIMIT 25;

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vTeQhfiGnOKZR09pDU6NVtRKgh3j-klUvjrfWnobbujy6p6PrT8bgQJmVYd39Ka01TnTNEELAtTPa54/pub?gid=1833809950&single=true&output=csv" AS row
MERGE (u1:User {id: toInteger(row[0])})
MERGE (u2:User {id: toInteger(row[1])})
MERGE (u2)-[:Responds{timeStamp: row[2]}]->(u1);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vToSSfCbLzhtuNVOUi-wibqce_r1iFo_MM23rylHiAmkGawP_HhOD7UnZqZV4jiFuNM6oOijicEDhLU/pub?gid=3429314&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[1])})
MERGE (c:ChatItem {id: toInteger(row[0])})
MERGE (u)<-[:Mentioned{timeStamp: row[2]}]-(c);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vT6KBP3pltLa9xa14Gi-uAtPXZf_tlf_O5E91VEJAoHw7COJU1gNTPYCpKfPpUZL6dp_u8av8dqGjNG/pub?gid=1446163877&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Leaves{timeStamp: row[2]}]->(c);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vTMZmBD2rjpAe2_JUN7AU1It1Bl0fopn9MAzLVWg4fjMUpooGYl4VLaVCWYf9Ll1YvDn2D47xip4rbp/pub?gid=67694025&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Joins{timeStamp: row[2]}]->(c);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vThOnVfmqmnMoNjlhKT-2lf8KishwO4uFCk3mMmomIjIGETn-UD3LQzSxb28NIxHpMT63Gf3etewPw4/pub?gid=1744559772&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (i:ChatItem {id: toInteger(row[2])})
MERGE (u)-[:CreateChat{timeStamp: row[3]}]->(i)
MERGE (i)-[:PartOf{timeStamp: row[3]}]->(c);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vQJVRjt76Z6SC1hiQQYkVua2LW0Phuaji_6p5ejx63Bu4uMipo3P4WBeeupFDbixkXm4fP2ZdE34IPW/pub?gid=1033180261&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);

CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

match (n) delete (n);

match (n)-[r]->(m) delete n, r;

match (u1)-[r:InteractsWith]->(u2)
where u1.id in [2067, 209, 668]
return u1, r, u2;

match (u1)-[r:InteractsWith]->(u2)
where u1.id in [394, 2067, 209, 1087, 554, 516, 1627, 999, 461, 668]
return u1, r, u2;

match (u1)-[r1:InteractsWith]->(u2)
where u1.id in [394, 2067, 209, 1087, 554, 516, 1627, 999, 461, 668]
with u1, collect(u2.id) as neighbours, count(distinct(u2)) as neighbourCount
match (u3)-[r2:InteractsWith]->(u4)
where u3.id in neighbours and u4.id in neighbours
with u1, u3, u4, neighbourCount, case when count(r2) > 0 then 1 else 0 end as answer
return u1.id, sum(answer) * 1.0 / (neighbourCount * (neighbourCount - 1)) as coef
order by coef desc limit 10;

match (u) -[:CreatesSession]-> (c) -[:OwnedBy]-> (t)
where u.id in [394, 2067, 209, 1087, 554, 516, 1627, 999, 461, 668] and t.id in [82, 185, 112, 18, 194, 129, 52, 136, 146, 81]
return u.id, t.id;

match (i)-[:PartOf]->(s)-[:OwnedBy]->(t)
return t.id, count(i)
order by count(i) desc
limit 10;

match (u)-[:CreateChat]->(c)
return u.id, count(c)
order by count(c) desc
limit 10;

match (u1)-[r1:InteractsWith]->(u2)
where u1.id in [394, 2067, 209]
with u1, collect(u2.id) as neighbours, count(distinct(u2)) as neighbourCount
match (u3)-[r2:InteractsWith]->(u4)
where u3.id in neighbours and u4.id in neighbours
with u1, u3, u4, neighbourCount, case when count(r2) > 0 then 1 else 0 end as answer
return u1.id, sum(answer) * 1.0 / (neighbourCount * (neighbourCount - 1)) as coef
order by coef desc limit 10;

match (u1)-[r1:InteractsWith]->(u2)
where u1.id in [394, 2067, 1087, 209, 554, 999, 516, 1627, 461, 668]
with u1, collect(u2.id) as neighbours, count(distinct(u2)) as neighbourCount
match (u3)-[r2:InteractsWith]->(u4)
where u3.id in neighbours and u4.id in neighbours
with u1, u3, u4, neighbourCount, case when count(r2) > 0 then 1 else 0 end as answer
return u1.id, sum(answer) * 1.0 / (neighbourCount * (neighbourCount - 1)) as coef
order by coef desc limit 10;

match (u1)-[r1:InteractsWith]->(u2)
where u1.id in [394, 2067, 1087, 209, 554, 999, 516, 1627, 461, 668]
with u1, collect(u2.id) as neighbours, count(distinct(u2)) as neighbourCount
match (u3)-[r2:InteractsWith]->(u4)
where u3.id in neighbours and u4.id in neighbours
with u1, u3, u4, neighbourCount, case when count(r2) > 0 then 1 else 0 end as answer
return u1.id, sum(answer) / (neighbourCount * (neighbourCount - 1)) as coef
order by coef desc limit 10;

match (u1)-[r1:InteractsWith]->(u2)
where u1.id in [394, 2067, 1087, 209, 554, 999, 516, 1627, 461, 668]
with u1, collect(u2.id) as neighbours, count(distinct(u2)) as neighbourCount
match (u3)-[r2:InteractsWith]->(u4)
where u3.id in neighbours and u4.id in neighbours
with u1, u3, u4, neightbourCount, case when count(r2) > 0 then 1 else 0 end as answer
return u1.id, sum(answer) / (neighbourCount * (neighbourCount - 1)) as coef
order by coef desc limit 10;

match (u1)-[r1:InteractsWith]->(u2)
where u1.id in [394, 2067, 1087, 209, 554, 999, 516, 1627, 461, 668]
with u1, collect(u2.id) as neighbours, count(distinct(u2)) as neighbourCount
match (u3)-[r2:InteractsWith]->(u4)
where u3.id in neighbours and u4.id in neighbours
with u1, u3, u4, neightbourCount
case when count(r2) > 0 then 1 else 0 end as answer
return u1.id, sum(answer) / (neighbourCount * (neighbourCount - 1)) as coef
order by coef desc limit 10;

match (u1)-[:Responds]->(u2)
where u1 <> u2
create (u1)-[:InteractsWith]->(u2);

MATCH p=()-[r:Responds]->() RETURN p LIMIT 25;

match (u1)-[:CreateChat]->(i)<-[:Mentioned]-(u2)
where u1 <> u2
create (u1)-[:InteractsWith]->(u2);

match (i)-[r:Mentioned]->(u2)
return i, r, u2
limit 40;

MATCH (n) RETURN n LIMIT 25;

match (u1)-[:CreateChat]->(i)-[:Mentioned]->(u2)
where u1 <> u2
create (u1)-[:InteractsWith]->(u2);

match (u1)-[:CreateChat]->(i1)-[:Responds]->(i2)
with u1, i1, i2
match (u2)-[:CreateChat]->(i2)
create (u1)-[:InteractsWith]->(u2);

match (u1)-[:CreateChat]->(i1)-[:Responds]->(i2)
with u1, i1, i2
match (u2)-[:CreateChat]->(i2)
where u1 <> u2
create (u1)-[:InteractsWith]->(u2);

match (u1:User)-[:CreateChat]->(i)-[:Mentioned]->(u2:User)
where u1 <> u2
create (u1)-[:InteractsWith]->(u2);

match (u) -[:CreatesSession]-> (c) -[:OwnedBy]-> (t)
where u.id in [394, 2067, 209] and t.id in [82, 185, 112]
return u.id, t.id;

match (u) -[:CreatesSession]-> (c) -[:OwnedBy]-> (t)
where u.id in [394, 2067, 209] and t.id in [82, 185, 112];

match (i)-[:PartOf]->(s)-[:OwnedBy]->(t)
return t.id, count(i)
order by count(i) desc
limit 3;

match (u)-[:CreateChat]->(c)
return u.id, count(c)
order by count(c) desc
limit 3;

match p=(a)-[:Responds*]->(b)
return p, length(p), [n in nodes(p)| n.id] as nodes
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
unwind [n in nodes(p)| n.id] as nodes
return p, length(p), nodes, collect(DISTINCT nodes)
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
return p, length(p), [n in nodes(p)| n.id] as nodes, count(DISTINCT (unwind [n in nodes(p)| n.id]))
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
return p, length(p), [n in nodes(p)| n.id] as nodes, count(DISTINCT [n in nodes(p)| n.id])
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
return p, length(p), nodes(p) as nodes, count(DISTINCT [n in nodes(p)| n.id])
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
return p, length(p), count(DISTINCT [n in nodes(p)| n.id])
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
return p, length(p), count(DISTINCT nodes(p))
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
return p, length(p), count(DISTINCT p)
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b)
return p, length(p)
order by length(p) desc
limit 5;

match p=(a)-[:Responds*]->(b);

match p=()- ->() return p limit 40;

MATCH (n) RETURN n LIMIT 50;

MATCH (n) RETURN n LIMIT 25;

match (n)-[r]->(m) return n, r, m limit 50;

match (n)-[r]->() return n, r limit 50;

match ()-[r]->() return r limit 50;

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vTeQhfiGnOKZR09pDU6NVtRKgh3j-klUvjrfWnobbujy6p6PrT8bgQJmVYd39Ka01TnTNEELAtTPa54/pub?gid=1833809950&single=true&output=csv" AS row
MERGE (u1:User {id: toInteger(row[0])})
MERGE (u2:User {id: toInteger(row[1])})
MERGE (u2)-[:Responds{timeStamp: row[2]}]->(u1);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vToSSfCbLzhtuNVOUi-wibqce_r1iFo_MM23rylHiAmkGawP_HhOD7UnZqZV4jiFuNM6oOijicEDhLU/pub?gid=3429314&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[1])})
MERGE (c:ChatItem {id: toInteger(row[0])})
MERGE (u)-[:Mentioned{timeStamp: row[2]}]->(c);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vT6KBP3pltLa9xa14Gi-uAtPXZf_tlf_O5E91VEJAoHw7COJU1gNTPYCpKfPpUZL6dp_u8av8dqGjNG/pub?gid=1446163877&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Leaves{timeStamp: row[2]}]->(c);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vTMZmBD2rjpAe2_JUN7AU1It1Bl0fopn9MAzLVWg4fjMUpooGYl4VLaVCWYf9Ll1YvDn2D47xip4rbp/pub?gid=67694025&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Joins{timeStamp: row[2]}]->(c);

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vThOnVfmqmnMoNjlhKT-2lf8KishwO4uFCk3mMmomIjIGETn-UD3LQzSxb28NIxHpMT63Gf3etewPw4/pub?gid=1744559772&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (i:ChatItem {id: toInteger(row[2])})
MERGE (u)-[:CreateChat{timeStamp: row[3]}]->(i)
MERGE (i)-[:PartOf{timeStamp: row[3]}]->(c);

// CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
// CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
// CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
// CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vQJVRjt76Z6SC1hiQQYkVua2LW0Phuaji_6p5ejx63Bu4uMipo3P4WBeeupFDbixkXm4fP2ZdE34IPW/pub?gid=1033180261&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);

match (n)-[r]->(m) delete n, r;

MATCH (n:ChatItem) RETURN n LIMIT 25;

match (n) delete (n);

match (n)-[r]->(m) delete n, r, m;

match (n)-[r]->(m) delete n, r, (m);

match (n) delete (n);

match (n)-[r]->(m) delete n, r;

// CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
// CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
// CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
// CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

LOAD CSV FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vQJVRjt76Z6SC1hiQQYkVua2LW0Phuaji_6p5ejx63Bu4uMipo3P4WBeeupFDbixkXm4fP2ZdE34IPW/pub?gid=1033180261&single=true&output=csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);

// CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
// CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
// CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
// CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

LOAD CSV FROM "file:<path>/chat_create_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);

CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

LOAD CSV FROM "file:<path>/chat_create_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);

CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

LOAD CSV FROM "file:<path>/chat_create_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);

match (n:Gene)-[r]-()
with n as nodes, count(distinct r) as degree
return degree, count(nodes) order by degree asc;

match (n:Gene)-[r]->()
return n.Name as Node, count(r) as Outdegree
order by Outdegree desc limit 2;

match (n:Gene)-[r]->()
return n.Name as Node, count(r) as Outdegree
order by Outdegree desc;

match (n:Gene)-[r]->()
return n.Name as Node, count(r) as Outdegree
order by Outdegree;

match path=allShortestPaths((from)-[:Association*]-(to))
where from.Name='BRCA1' and to.Name='NBR1'
return count(path);

match path=allShortestPaths((from)-[:TO*]-(to))
where from.Name='BRCA1' and to.Name='NBR1'
return count(path);

match path=allShortestPaths((from)-[:TO*]-(to))
where from.Name='BRCA1' and to.Name='NBR1'
return count(p);

match p=(n {Name:'BRCA1'})-[:Association*..2]->(m) return p;

match p=(n {Name:'BRCA1'})-[:AssociationType*..2]->(m) return p;

match (n)-[r]->(m) where m <> n return distinct n, m, count(r) as myCount order by myCount desc limit 1;

match (n)-[r]->(m) where m <> n return distinct n, m, count(r);

match (n)-[r]->() return count(r);

match (n)-[r]->() return count( r);

match (n) return count(n);

match (n)-[r]->(n) return count(r);

match (n)-[r]->() return count(DISTINCT r);

match (n) return count(distinct n);

LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vQKbCHoLKDqvBy5phBEFUb9bvOwx4I1fYr7yTC3Xgm8TSIKykfK1tfQ8mwHKaLz7V1cuuJEhQye6bjd/pub?gid=1266829800&single=true&output=csv" AS line
MERGE (n:Gene {Name:line.OFFICIAL_SYMBOL_A})
MERGE (m:Gene {Name:line.OFFICIAL_SYMBOL_B})
MERGE (n) -[:Association {assoc:line.EXPERIMENTAL_SYSTEM}]-> (m);

match (n) delete n;

match (n)-[r]-() delete n, r;

LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vQKbCHoLKDqvBy5phBEFUb9bvOwx4I1fYr7yTC3Xgm8TSIKykfK1tfQ8mwHKaLz7V1cuuJEhQye6bjd/pub?gid=1266829800&single=true&output=csv" AS line
MERGE (n:Gene {Name:line.OFFICIAL_SYMBOL_A})
MERGE (m:Gene {Name:line.OFFICIAL_SYMBOL_B})
MERGE (n) -[:Association {dist:line.EXPERIMENTAL_SYSTEM}]-> (m);

match (n) delete n;

match (n)-[r]-() delete n, r;

:play http://localhost:11001/project-1d249076-3e4c-4a05-a21f-5f321ffd34fd\about-movies.neo4j-browser-guide