drop database if exists music_data_store;
create database if not exists music_data_store;
use music_data_store;

-- Creating the Employee table
drop table if exists employee;
create table if not exists employee(employee_id int primary key,
last_name text,
first_name text,
title text,
reports_to varchar(10),
levels text,
birthdate text,
hire_date text,
address text,
city text,
state text,
country text,
postal_code text,
phone varchar(20),
fax text,
email text);

select COUNT(*) from employee;

-- Creating the Customer table
drop table if exists customer;
create table if not exists customer(customer_id int primary key,
first_name varchar(50),
last_name varchar(50),
company varchar(50),
address varchar(50),
city varchar(50),
state varchar(50),
country varchar(50),
postal_code varchar(50),
phone varchar(50),
fax varchar(50),
email varchar(100),
support_rep_id  int);
-- ======================== ADDING FOREIGN KEY =======================================
alter table customer add constraint fk_customer_support_rep_id
foreign key (support_rep_id) references employee(employee_id) on update cascade on delete cascade;

select COUNT(*) from customer;


-- Creating the Invoice table
drop table if exists invoice;
create table if not exists invoice(invoice_id int not null primary key,
customer_id int,
invoice_date date,
billing_address varchar(50),
billing_city varchar(50),
billing_state varchar(50),
billing_country varchar(50),
billing_postal_code varchar(50),
total decimal(10,2));
-- ======================== ADDING FOREIGN KEY =======================================
alter table invoice add constraint fk_customer_customer_id
foreign key (customer_id) references customer(customer_id) on update cascade on delete cascade;

select COUNT(*) from invoice;

-- Creating the artist table
drop table if exists artist;
create table if not exists artist(artist_id int primary key,
name text);

select COUNT(*) from artist;

-- Creating the album table
drop table if exists album;
create table if not exists album(album_id int primary key,
title text,
artist_id int);
-- ======================== ADDING FOREIGN KEY =======================================
alter table album add constraint fk_album_artist_id
foreign key(artist_id) references artist(artist_id) on update cascade on delete cascade;

select COUNT(*) from album;


-- Creating the genre table
drop table if exists genre;
create table if not exists genre(genre_id int primary key,
name varchar(50));
 
 select COUNT(*) from genre;
 
 
-- Creating the media_type table
drop table if exists media_type;
create table if not exists media_type(media_type_id int primary key,
name varchar(50));

select COUNT(*) from media_type;

-- Creating the track table
drop table if exists track;
create table if not exists track(track_id int primary key,
name text,
album_id int,
media_type_id int,
genre_id int,
composer text,
milliseconds int,
bytes text,
unit_price decimal(10,2));
-- ======================== ADDING FOREIGN KEY =======================================
alter table track add constraint fk_track_media_type_id
foreign key (media_type_id) references media_type(media_type_id) on update cascade on delete cascade;
alter table track add constraint fk_track_genre_id
foreign key (genre_id) references genre(genre_id) on update cascade on delete cascade;
alter table track add constraint fk_track_album_id
foreign key(album_id) references album(album_id) on update cascade on delete cascade;

select COUNT(*) from track;

-- Creating the Invoice_line table
drop table if exists invoice_line;
create table if not exists invoice_line(invoice_line_id int primary key,
invoice_id int,
track_id int,
unit_price decimal(10,2),
quantity smallint);
-- ======================== ADDING FOREIGN KEY =======================================
alter table invoice_line add constraint fk_invoice_line_track_id
foreign key (track_id) references track(track_id) on update cascade on delete cascade;
alter table invoice_line add constraint fk_invoice_line_invoice_id
foreign key (invoice_id) references invoice(invoice_id) on update cascade on delete cascade;

select COUNT(*) from invoice_line;

-- Creating the playlist table
drop table if exists playlist;
create table if not exists playlist(playlist_id int primary key,
name varchar(50));

select COUNT(*) from playlist;


-- Creating the playlist_track table
drop table if exists playlist_track;
create table if not exists playlist_track(playlist_id int ,
track_id int);
alter table playlist_track add constraint fk_playlist_track_playlist_id
foreign key(playlist_id) references playlist(playlist_id) on update cascade on delete cascade;
alter table playlist_track add constraint fk_playlist_track_track_id
foreign key(track_id) references track(track_id) on update cascade on delete cascade;


select COUNT(*) from playlist_track;
