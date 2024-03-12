drop table if exists courses, reviews cascade;


create table courses
(
	id int primary key generated by default as identity,
	title text,
	description text
);

create table reviews
(
	id int primary key generated by default as identity,
	course_id int references courses(id),
	content text,
	rating int
);

insert into courses(title, description)
values
('Programming', 'We will teach you how to use a PC!! and we have python!!'),
('Networking', 'We will teach you how to turn on your WI-FI!! and we have cables!!'),
('Hotel Business', 'We will teach you how to use a vacuum cleaner!! and we have german!!');

insert into reviews(course_id, content, rating)
values
(1, 'Cool, thats cool!', 5),
(1, 'Its okay', 4),
(2, 'Such awesome guys studying here', 5),
(3, 'Questionable, but okay', 3);

select * from courses;

select * from reviews;

select *
from courses
         left join reviews on courses.id = reviews.course_id;

select
  co.id,
  co.title,
  co.description,
  coalesce(json_agg(json_build_object(
    'id', rev.id, 'content', rev.content, 'rating', rev.rating))
      filter (where rev.id is not null), '[]')
        as reviews
from courses co
left join reviews rev on co.id = rev.course_id
group by co.id
order by co.id;