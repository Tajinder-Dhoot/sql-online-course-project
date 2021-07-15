create database events;
use events;

create table timestamps (
	timestamps_via_event datetime
);

create event first_event
	on schedule every 5 second     #records event every 5 seconds of creating the event
    do
		insert into timestamps values(now());
        
create event second_event
on schedule at current_timestamp + interval 7 second      #records event after 7 seconds of creating tyhe event
	do
		insert into timestamps values (now());
        
select * from timestamps;
select time(timestamps_via_event) from timestamps;

drop event first_event;
drop event second_event;