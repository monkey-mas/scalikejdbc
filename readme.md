# ScalikeJDBC

## Just write SQL and get things done!

ScalikeJDBC is a tidy SQL-based DB access library for Scala that naturally wraps JDBC and provides easy-to-use APIs.

ScalikeJDBC is practical and production-ready. Use this library for your real projects.

http://scalikejdbc.org/

[![Build Status](https://travis-ci.org/scalikejdbc/scalikejdbc.svg?branch=master)](https://travis-ci.org/scalikejdbc/scalikejdbc)
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.scalikejdbc/scalikejdbc_2.11/badge.svg)](https://maven-badges.herokuapp.com/maven-central/org.scalikejdbc/scalikejdbc_2.11)

## Gitter Chat for Casual Q&A

- English: [![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/scalikejdbc/en?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
- 日本語 (Japanese): [![Gitter](https://badges.gitter.im/_チャットへ.svg)](https://gitter.im/scalikejdbc/ja?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Getting Started

Just add ScalikeJDBC, a JDBC driver, and an slf4j implementation to your sbt build settings:

```scala
libraryDependencies ++= Seq(
  "org.scalikejdbc" %% "scalikejdbc"        % "2.4.+",
  "com.h2database"  %  "h2"                 % "1.4.+",
  "ch.qos.logback"  %  "logback-classic"    % "1.1.+"
)
```

If you're a Play2 user, take a look at play-support project, too:

https://github.com/scalikejdbc/scalikejdbc-play-support

#### First example

After adding the above dependencies to your `build.sbt`, run `sbt console` and execute the following code:

```scala
import scalikejdbc._

// initialize JDBC driver & connection pool
Class.forName("org.h2.Driver")
ConnectionPool.singleton("jdbc:h2:mem:hello", "user", "pass")

// ad-hoc session provider on the REPL
implicit val session = AutoSession

// table creation, you can run DDL statements using #execute as with JDBC
sql"""
create table members (
  id serial not null primary key,
  name varchar(64),
  created_at timestamp not null
)
""".execute.apply()

// insert initial data
Seq("Alice", "Bob", "Chris") foreach { name =>
  sql"insert into members (name, created_at) values (${name}, current_timestamp)".update.apply()
}

// retrieve all data as a List of Map elements
val entities: List[Map[String, Any]] = sql"select * from members".map(_.toMap).list.apply()

// define an entity object and extractor
import org.joda.time._
case class Member(id: Long, name: Option[String], createdAt: DateTime)
object Member extends SQLSyntaxSupport[Member] {
  override val tableName = "members"
  def apply(rs: WrappedResultSet): Member = new Member(
    rs.long("id"), rs.stringOpt("name"), rs.jodaDateTime("created_at"))
}

// find all Members
val members: List[Member] = sql"select * from members".map(rs => Member(rs)).list.apply()
```

How did it go? If you'd like to know more details or see more practical examples, see the full documentation at:

http://scalikejdbc.org/


## License

Published source code and binary files have the following copyright:

```
Copyright scalikejdbc.org
Apache License, Version 2.0
http://www.apache.org/licenses/LICENSE-2.0.html
```

