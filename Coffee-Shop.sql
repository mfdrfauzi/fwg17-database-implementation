create type "userRole" as enum ('admin', 'staff', 'customer');
create table if not exists "users" (
"id" serial primary key,
"fullName" varchar(30) not null,
"email" varchar(30) unique not null,
"password" varchar(20) check(length(password) >= 6) not null,
"address" text,
"picture" text,
"phoneNumber" varchar(15) not null,
"role" "userRole" not null,
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "products" (
"id" serial primary key,
"name" varchar(30) not null,
"description" text not null,
"basePrice" numeric(12,2) not null,
"image" text,
"discount" float,
"isRecommended" bool,
"created_at" timestamp default now(),
"updated_at" timestamp
);

create type "sizeProduct" as enum ('small', 'medium', 'large');
create table if not exists "productSize" (
"id" serial primary key,
"size" "sizeProduct" not null,
"additionalPrice" numeric(12,2),
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "productVariant" (
"id" serial primary key,
"name" varchar(30) not null,
"additionalPrice" numeric(12,2),
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "tags" (
"id" serial primary key,
"name" varchar(30) not null,
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "productTags" (
"id" serial primary key,
"productId" int references "products"("id"),
"tagId" int references "tags"("id"),
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "productRatings" (
"id" serial primary key,
"productId" int references "products"("id"),
"rate" int check (rate >= 0 and rate <= 5),
"reviewMessage" text,
"userId" int references "users"("id"),
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "categories" (
"id" serial primary key,
"name" varchar(30) not null,
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "productCategories" (
"id" serial primary key,
"productId" int references "products"("id"),
"categoryId" int references "categories"("id"),
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "promos" (
"id" serial primary key,
"name" varchar(30) not null,
"code" varchar(30) not null,
"description" text,
"percentage" float,
"isExpired" bool,
"maximumPromo" numeric(12,2) not null,
"minimumAmount" numeric(12,2) not null,
"created_at" timestamp default now(),
"updated_at" timestamp
);

create type "orderStatus" as enum ('on-progress','delivered','canceled','ready-to-pick');
create table if not exists "orders" (
"id" serial primary key,
"userId" int references "users"("id"),
"orderNumber" varchar(15) unique not null,
"promoId" int references "promos"("id"),
"total" numeric(12,2),
"taxAmount" numeric(12,2) generated always as ("total" * 0.10) stored,
"status" "orderStatus" not null,
"deliveryAddress" text not null,
"fullName" varchar(30) not null,
"email" varchar(30) not null,
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "orderDetails" (
"id" serial primary key,
"productId" int references "products"("id"),
"productSizeId" int references "productSize"("id"),
"productVariantId" int references "productVariant"("id"),
"quantity" int not null,
"orderId" int references "orders"("id"),
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "messages" (
"id" serial primary key,
"receipentId" int references "users"("id") on delete cascade,
"senderId" int references "users"("id") on delete cascade,
"text" text,
"created_at" timestamp default now(),
"updated_at" timestamp
);

insert into "users" ("fullName","email","password","address","phoneNumber","role")
values
	('Rizky Ananda', 'rizky.ananda@gmail.com', 'P@ssw0r', 'Jl. Merdeka No. 123, Jakarta', '081234567890', 'admin'),
	('Siti Rahayu', 'siti.rahayu12@gmail.com', 'S1t!P@ss', 'Jl. Jendral Sudirman No. 45, Surabaya', '081345678901', 'staff'),
	('Dewi Pratiwi', 'dewi.pratiwi@gmail.com', 'D3w!P@ss', 'Jl. Diponegoro No. 67, Bandung', '081456789012', 'customer'),
	('Aldi Wijaya', 'aldi.wijaya2@gmail.com', 'A1d!P@ss', 'Jl. Gajah Mada No. 89, Yogyakarta', '081567890123', 'admin'),
	('Putri Kusuma', 'putri.kusuma2@gmail.com', 'P2tr!P@ss', 'Jl. Surya Kencana No. 34, Semarang', '081678901234', 'staff'),
	('Budi Setiawan', 'budi.setiawan2@gmail.com', 'Bud!P@ss', 'Jl. Pahlawan No. 56, Medan', '081789012345', 'customer'),
	('Siti Rahmawati', 'siti.rahmawati@gmail.com', 'S1t!P@ss', 'Jl. Jendral Sudirman No. 34, Makassar', '081789012345', 'staff'),
	('Fauzi Pratama', 'fauzi.pratama@gmail.com', 'F@!z!P@ss', 'Jl. Gajah Mada No. 67, Palembang', '081890123456', 'customer'),
	('Anita Putri', 'anita.putri@gmail.com', 'An!t@P@ss', 'Jl. Diponegoro No. 12, Medan', '081901234567', 'staff'),
	('Yusuf Setiawan', 'yusuf.setiawan@gmail.com', 'Y!s!fP@ss', 'Jl. Jendral Sudirman No. 56, Pontianak', '081012345678', 'customer'),
	('Alya Indah', 'alya.indah@gmail.com', 'A1y@P@ss', 'Jl. Merdeka No. 23, Batam', '081123456789', 'customer'),
	('Budi Santoso', 'budi.santoso@gmail.com', 'Bud!P@ss', 'Jl. Teuku Umar No. 45, Balikpapan', '081234567890', 'customer');
	
insert into "products" ("name","description","basePrice","discount","isRecommended")
values
	('Kopi Tubruk', 'kopi khas Jawa', 20000, 0, true),
	('Kopi Latte', 'kopi susu dengan rasa lembut', 25000, 0, true),
	('Kopi Tarik', 'kopi Malaysia', 22000, 0, true),
	('Kopi Hitam', 'kopi hitam tanpa gula', 18000, 0, true),
	('Kopi Toraja', 'kopi Toraja', 28000, 0, true),
	('Kopi Mocha', 'kopi dengan rasa cokelat', 26000, 0, true),
	('Kopi Cappuccino', 'kopi dengan busa susu', 28000, 0, true),
	('Kopi Espresso', 'kopi kuat tanpa gula', 20000, 0, true),
	('Kopi Kopi Kopi', 'kopi dengan rasa kopi kuat', 22000, 0, true),
	('Kopi Kenangan', 'kopi kenangan masa lalu', 26000, 0, true),
	('Kopi Vietnam', 'kopi gayo dari Vietnam', 28000, 0, true),
	('Kopi Rum Raisin', 'kopi dengan rasa rum raisin', 25000, 0, true),
	('Kopi Blue Mountain', 'kopi blue mountain', 26000, 0, true),
	('Kopi Tiramisu', 'kopi dengan rasa tiramisu', 23000, 0, true),
	('Kopi Keju', 'kopi dengan rasa keju', 23000, 0, true),
	('Kopi Aceh Gayo', 'kopi aceh gayo', 27000, 0, true),
	('Kopi Tubruk', 'kopi khas Jawa', 20000, 0, true),
	('Mie Gomak', 'Mie khas Batak', 26000, 0, true),
	('Nasi Rawon', 'nasi rawon', 35000, 0, true),
	('Nasi Goreng', 'nasi goreng dengan telur dan ayam', 35000, 0, true),
	('Mie Ayam', 'Mie ayam dengan daging ayam', 25000, 0, true),
	('Nasi Kuning', 'nasi kuning dengan telur dan ayam', 32000, 0, true),
	('Nasi Rendang', 'nasi rendang', 38000, 0, true),
	('Nasi Ayam Geprek', 'nasi ayam geprek dengan sambal', 35000, 0, true),
	('Nasi Soto', 'nasi soto ayam dengan kuah kaldu', 30000, 0, true),
	('Nasi Kari', 'nasi kari ayam dengan kuah kari', 33000, 0, true),
	('Nasi Pecel', 'nasi pecel dengan sayuran', 32000, 0, true),
	('Nasi Timbel', 'nasi timbel khas Sunda', 33000, 0, true),
	('Nasi Liwet', 'nasi liwet khas Solo', 33000, 0, true),
	('Nasi Uduk', 'nasi uduk khas Betawi', 35000, 0, true),
	('Nasi Kuning Padang', 'nasi kuning padang', 35000, 0, true),
	('Nasi Ikan', 'nasi ikan dengan kuah ikan', 34000, 0, true),
	('Nasi Goreng Seafood', 'nasi goreng dengan seafood', 38000, 0, true),
	('Roti Bakar', 'Roti tawar yang dipanggang', 12000, 0, true),
	('Pancake Blueberry', 'Pancake dengan saus blueberry', 18000, 0, true),
	('Mie Rebus', 'Mie rebus dengan kuah kaldu', 25000, 0, true),
	('Mie Tom Yum', 'Mie tom yum pedas', 27000, 0, true),
	('Mie Jepang', 'Mie jepang dengan saus kecap', 27000, 0, true),
	('Mie Szechuan', 'Mie szechuan pedas', 29000, 0, true),
	('Mie Udon', 'Mie udon dengan kuah kaldu', 28000, 0, true),
	('Mie Singapura', 'Mie singapura dengan saus kecap', 28000, 0, true),
	('Mie Goreng Aceh', 'Mie goreng aceh pedas', 27000, 0, true),
	('Mie Tek Tek', 'Mie tek tek dengan kerupuk', 28000, 0, true),
	('Mie Jawa', 'Mie jawa dengan bumbu kacang', 28000, 0, true),
	('Mie Pempek', 'Mie pempek khas Palembang', 29000, 0, true),
	('Mie Kung Pao', 'Mie kung pao pedas', 28000, 0, true),
	('Mie Goreng', 'mie goreng dengan saus pedas', 28000, 0, true),
	('Roti Lapis', 'Roti dengan isian selai', 16000, 0, true),
	('Nasi Goreng Jawa', 'nasi goreng khas Jawa', 32000, 0, true),
	('Teh Tubruk', 'teh khas Jawa', 15000, 0, true),
	('Cokelat Panas', 'cokelat panas', 22000, 0, true),
	('Kopi Kopi Kopi', 'kopi dengan rasa kopi kuat', 22000, 0, true),
	('Teh Tarik', 'teh Malaysia', 18000, 0, true),
	('Cappuccino', 'cappuccino dengan busa susu', 25000, 0, true),
	('Kopi Arabika', 'kopi arabika', 24000, 0, true),
	('Caramel Macchiato', 'kopi dengan rasa caramel', 26000, 0, true),
	('Espresso', 'kopi kuat tanpa gula', 19000, 0, true),
	('Kopi Kenangan', 'kopi kenangan masa lalu', 26000, 0, true),
	('Kopi Robusta', 'kopi robusta', 22000, 0, true),
	('Iced Americano', 'kopi hitam dingin', 21000, 0, true),
	('Kopi Gula Aren', 'kopi dengan rasa gula aren', 27000, 0, true),
	('Teh Manis', 'teh manis tanpa gula', 16000, 0, true),
	('Espresso Machiato', 'kopi dengan rasa caramel', 26000, 0, true),
	('Kopi Brazil', 'kopi khas Brazil', 28000, 0, true),
	('Affogato', 'kopi dengan es krim', 30000, 0, true),
	('Kopi India', 'kopi khas India', 27000, 0, true),
	('Nasi Goreng Spesial', 'nasi goreng spesial', 33000, 0, true),
	('Mie Ayam Spesial', 'Mie ayam spesial', 26000, 0, true),
	('Nasi Rendang Minang', 'nasi rendang Minang', 38000, 0, true),
	('Nasi Goreng Cakalang', 'nasi goreng cakalang', 32000, 0, true),
	('Mie Aceh', 'Mie Aceh pedas', 27000, 0, true),
	('Nasi Soto Medan', 'nasi soto Medan', 31000, 0, true),
	('Nasi Rawon Surabaya', 'nasi rawon Surabaya', 34000, 0, true),
	('Nasi Liwet Solo', 'nasi liwet Solo', 33000, 0, true),
	('Nasi Uduk Betawi', 'nasi uduk Betawi', 35000, 0, true),
	('Nasi Kuning Padang', 'nasi kuning Padang', 36000, 0, true),
	('Nasi Ikan Manado', 'nasi ikan Manado', 37000, 0, true),
	('Nasi Timbel Sunda', 'nasi timbel Sunda', 36000, 0, true),
	('Nasi Gudeg Jogja', 'nasi gudeg Jogja', 32000, 0, true),
	('Nasi Goreng Jawa Tengah', 'nasi goreng Jawa Tengah', 33000, 0, true),
	('Nasi Rames Betawi', 'nasi rames Betawi', 34000, 0, true),
	('Donat Klasik', 'Donat dengan taburan gula', 12000, 0, true),
	('Brownies Klasik', 'Brownies cokelat', 15000, 0, true),
	('Roti Isi Keju', 'Roti dengan isi keju', 12000, 0, true),
	('Donat Cokelat Melted', 'Donat dengan cokelat meleleh', 13000, 0, true),
	('Kue Pisang', 'Kue dengan potongan pisang', 14000, 0, true),
	('Roti Manis Cinnamon', 'Roti manis dengan kayu manis', 13000, 0, true),
	('Donat Buah Mix', 'Donat dengan campuran potongan buah', 14000, 0, true),
	('Kue Lapis Legit', 'Kue lapis legit', 18000, 0, true),
	('Roti Gurih Keju', 'Roti gurih dengan keju', 15000, 0, true),
	('Donat M&M', 'Donat dengan M&M', 13000, 0, true),
	('Kue Keju Nanas', 'Kue keju dengan potongan nanas', 14000, 0, true),
	('Pancake Choco Chip', 'Pancake dengan choco chip', 18000, 0, true),
	('Roti Gandum', 'Roti gandum sehat', 14000, 0, true),
	('Donat Rainbow', 'Donat dengan hiasan warna-warni', 14000, 0, true),
	('Kue Strawberry Shortcake', 'Kue strawberry shortcake', 18000, 0, true),
	('Roti Tawar', 'Roti tawar biasa', 10000, 0, true),
	('Nasi Kuning Betawi', 'nasi kuning Betawi', 34000, 0, true);
	
insert into "productSize" ("size","additionalPrice")
values
	('small',0),
	('medium',5000),
	('large',8000);
	
insert into "productVariant" ("name","additionalPrice")
values
	('hot',0),
	('cold',0),
	('pedas 1-5',0),
	('pedas 6-10',2000);
	
insert into "tags" ("name")
values 
	('Buy 1 Get 1'),
	('Flash sale'),
	('Birthday Package'),
	('Cheap');
	
insert into "productTags"("productId","tagId")
values
	(1, 4), (2, 4), (3, 2), (4, 1), (5, 4), (6, 3), (7, 4), (8, 4), (9, 3), (10, 3), (11, 4),
	(12, 2), (13, 3), (14, 2), (15, 4), (16, 4), (17, 3), (18, 4), (19, 3), (20, 2), (21, 3),
	(22, 3), (23, 3), (24, 2), (25, 1), (26, 2), (27, 3), (28, 3), (29, 2), (30, 4), (31, 3),
	(32, 3), (33, 4), (34, 4), (35, 2), (36, 1), (37, 3), (38, 4), (39, 1), (40, 2), (41, 1),
	(42, 2), (43, 2), (44, 1), (45, 2), (46, 1), (47, 4), (48, 4), (49, 2), (50, 3), (51, 2),
	(52, 4), (53, 3), (54, 3), (55, 4), (56, 1), (57, 4), (58, 3), (59, 1), (60, 4), (61, 3),
	(62, 1), (63, 3), (64, 4), (65, 2), (66, 2), (67, 1), (68, 4), (69, 4), (70, 1), (71, 2),
	(72, 2), (73, 4), (74, 2), (75, 1), (76, 4), (77, 3), (78, 3), (79, 1), (80, 4), (81, 3), 
	(82, 4), (83, 4), (84, 3), (85, 3), (86, 2), (87, 1), (88, 1), (89, 3), (90, 3), (91, 2),
	(92, 2), (93, 4), (94, 4), (95, 4), (96, 3), (97, 4), (98, 2), (1, 3),
	(2, 3), (3, 3), (4, 4), (5, 1), (6, 3), (7, 1), (8, 2), (9, 1), (10, 1), (11, 2), (12, 3),
	(13, 4), (14, 1), (15, 4), (16, 2), (17, 3), (18, 4), (19, 2), (20, 2), (21, 3), (22, 1),
	(23, 4), (24, 1), (25, 2), (26, 4), (27, 4), (28, 3), (29, 3), (30, 2), (31, 1), (32, 4),
	(33, 4), (34, 1), (35, 1), (36, 3), (37, 3), (38, 2), (39, 4), (40, 3), (41, 2), (42, 4),
	(43, 2), (44, 4), (45, 2), (46, 4), (47, 4), (48, 2), (49, 3), (50, 3), (51, 4), (52, 1),
	(53, 3), (54, 2), (55, 2), (56, 3), (57, 1), (58, 4), (59, 4), (60, 2), (61, 4), (62, 3),
	(63, 2), (64, 1), (65, 4), (66, 1), (67, 3), (68, 3), (69, 1), (70, 1), (71, 4), (72, 2),
	(73, 2), (74, 2), (75, 1), (76, 4), (77, 3), (78, 3), (79, 4), (80, 1), (81, 2), (82, 4),
	(83, 2), (84, 3), (85, 1), (86, 3), (87, 4), (88, 2), (89, 2), (90, 4), (91, 2), (92, 3),
	(93, 1), (94, 3), (95, 2), (96, 3), (97, 3), (98, 3);

select "p"."name" as "productName", "t"."name" as "tag"
from "products" "p" 
join "productTags" "pt" on "p"."id" = "pt"."productId"
join "tags" "t" on "pt"."tagId" = "t"."id" order by "p"."name";

insert into "productRatings" ("productId", "rate", "reviewMessage", "userId")
values 
	(1, 4, 'Sangat suka dengan rasa kopinya!', 3),
	(2, 5, 'Rasa kopi lembut dan susunya pas!', 6),
	(3, 4, 'Saya suka dengan cita rasanya yang khas.', 10),
	(20, 4, 'Nasi gorengnya enak dan porsi cukup besar.', 11),
	(23, 5, 'Rendangnya empuk dan bumbunya pas.', 3),
	(30, 4, 'Nasi uduknya gurih dan lezat.', 6),
	(48, 5, 'Roti lapisnya enak dan lembut.', 10),
	(83, 4, 'Browniesnya lezat dan manisnya pas.', 11),
	(84, 4, 'Roti isi kejunya nikmat dan kejunya melimpah.', 3),
	(96, 5, 'Kuenya enak dan strawberry segarnya luar biasa.', 6);

select "p"."name" as "productName", "u"."fullName" as "customerName", "pr"."reviewMessage" as "review"
from "products" "p" 
join "productRatings" "pr" on "p"."id" = "pr"."productId"
join "users" "u" on "pr"."userId" = "u"."id" order by "p"."name";

insert into "categories" ("name")
values
	('Favorite Product'),
	('Coffee'),
	('Non Coffee'),
	('Foods'),
	('Add On');

insert into "productCategories" ("productId","categoryId")
values 
	(1,2), (2,2), (3,2), (4,2), (5,2), (6,2), (7,2), (8,2), (9,2), (10,2), (11,2), (12,2),
	(13,2), (14,2), (15,2), (16,2), (17,2), (18,4), (19,4), (20,4), (21,4), (22,4), (23,4), (24,4),
	(25,4), (26,4), (27,4), (28,4), (29,4), (30,4), (31,4), (32,4), (33,4), (34,5), (35,5), (36,4),
	(37,4), (38,4), (39,4), (40,4), (41,4), (42,4), (43,4), (44,4), (45,4), (46,4), (47,4), (48,5),
	(49,4), (50,5), (51,5), (52,2), (53,5), (54,2), (55,2), (56,2), (57,2), (58,2), (59,2), (60,2),
	(61,2), (62,5), (63,2), (64,2), (65,2), (66,2), (67,4), (68,4), (69,4), (70,4), (71,4), (72,4),
	(73,4), (74,4), (75,4), (76,4), (77,4), (78,4), (79,4), (80,4), (81,4), (82,4), (83,4), (84,4),
	(85,4), (86,4), (87,4), (88,4), (89,4), (90,4), (91,4), (92,4), (93,5), (94,4), (95,4), (96,4),
	(97,4), (98,4), (1,1), (10,1), (23,1), (32,1), (47,1), (52,1), (61,1), (73,1), (81,1), (98,1);

select "p"."name" as "productName", "c"."name" as "category"
from "products" "p" 
join "productCategories" "pc" on "p"."id" = "pc"."productId"
join "categories" "c" on "pc"."categoryId" = "c"."id" order by "c"."name";

insert into "promos" ("name", "code", "description", "percentage", "isExpired", "maximumPromo", "minimumAmount")
values
    ('Promo Kopi Gratis', 'FREECOFFEE', 'Dapatkan kopi gratis setiap pembelian 5 kopi.', 100, false, 10000, 25000),
    ('Diskon 20% Kopi Latte', 'LATTE20', 'Diskon 20% untuk kopi latte pilihanmu.', 20, false, 5000, 15000),
    ('Kopi Tarik Hemat', 'TARIK5', 'Dapatkan diskon 5% untuk setiap kopi tarik.', 5, false, 8000, 20000),
    ('Promo Double Espresso', 'DOUBLEESP', 'Dapatkan double espresso dengan harga khusus.', 50, false, 15000, 30000),
    ('Hari Ini Cuma 10K', 'TENKOFF', 'Hari ini semua kopi hanya 10 ribu rupiah.', 100, false, 10000, 20000),
    ('Kopi Keju Lezat', 'CHEESEJAVA', 'Nikmati kopi keju favoritmu dengan harga khusus.', 15, false, 7500, 25000),
    ('Kopi Vietnam Spesial', 'VIETCOFFEE', 'Dapatkan diskon spesial untuk kopi Vietnam.', 30, false, 6000, 12000),
    ('Kopi Blue Mountain', 'BLUMTNJAVA', 'Kopi Blue Mountain dengan diskon khusus.', 25, false, 12500, 30000),
    ('Promo Mocha Enak', 'MOCHADEL', 'Nikmati mocha lezat dengan harga hemat.', 10, false, 6000, 15000),
    ('Espresso Gratis', 'FREEESP', 'Beli 2 espresso, dapatkan 1 espresso gratis.', 100, false, 8000, 18000);   

--update 10/11/2023
   
alter table "products"
alter column "basePrice" type int using "basePrice"::int;

alter table "products"
alter column "discount" type int using "discount"::int;

alter table "productSize"
alter column "additionalPrice" type int using "additionalPrice"::int;

alter table "productVariant"
alter column "additionalPrice" type int using "additionalPrice"::int;

alter table "promos"
alter column "percentage" type int using "percentage"::int;

alter table "users"
alter column "password" type varchar(100);

update "promos"
set "isExpired" = null;

--orders
   
insert into "orders" ("userId", "orderNumber", "total", "status", "deliveryAddress", "fullName", "email")
values (1, 'ord1', (select "basePrice" from "products" where "id" = 32), 'on-progress', 'Jl. Merdeka No. 123, Jakarta', 'Rizky Ananda', 'rizky.ananda@gmail.com');

insert into "orderDetails" ("productId", "productVariantId", "productSizeId", "quantity", "orderId")
values (32, 1, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord1'));


alter table "orders"
alter column "deliveryAddress" drop not null;

insert into "orders" ("userId", "orderNumber", "total", "status", "deliveryAddress", "fullName", "email")
values 
    (2, 'ord2', (select "basePrice" from "products" where "id" = 57), 'ready-to-pick', null, 'Siti Rahayu', 'siti.rahayu12@gmail.com'),
    (2, 'ord3', (select "basePrice" from "products" where "id" = 40), 'ready-to-pick', null, 'Siti Rahayu', 'siti.rahayu12@gmail.com'),
    (2, 'ord4', (select "basePrice" from "products" where "id" = 64), 'ready-to-pick', null, 'Siti Rahayu', 'siti.rahayu12@gmail.com');

insert into "orderDetails" ("productId", "productVariantId", "productSizeId", "quantity", "orderId")
values
    (57, 1, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord2')),
    (40, 2, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord3')),
    (64, 3, 3, 1, (select "id" from "orders" where "orderNumber" = 'ord4'));


insert into "orders" ("userId", "orderNumber", "total", "status", "deliveryAddress", "fullName", "email")
values (3, 'ord5', (select SUM("basePrice") from "products" where "id" in (48, 22, 12, 67, 41)), 'delivered', 'Jl. Diponegoro No. 67, Bandung', 'Dewi Pratiwi', 'dewi.pratiwi@gmail.com');

insert into "orderDetails" ("productId", "productVariantId", "productSizeId", "quantity", "orderId")
values (48, 1, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord5')),
       (22, 2, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord5')),
       (12, 3, 3, 1, (select "id" from "orders" where "orderNumber" = 'ord5')),
       (67, 1, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord5')),
       (41, 2, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord5'));


insert into "orders" ("userId", "orderNumber", "total", "status", "deliveryAddress", "fullName", "email")
values (4, 'ord6', (select SUM("basePrice") from "products" where "id" in (75, 3, 51, 35, 63)), 'ready-to-pick', null, 'Aldi Wijaya', 'aldi.wijaya2@gmail.com');

insert into "orderDetails" ("productId", "productVariantId", "productSizeId", "quantity", "orderId")
values (75, 1, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord6')),
       (3, 2, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord6')),
       (51, 3, 3, 1, (select "id" from "orders" where "orderNumber" = 'ord6')),
       (35, 1, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord6')),
       (63, 2, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord6'));


insert into "orders" ("userId", "orderNumber", "total", "status", "deliveryAddress", "fullName", "email")
values (5, 'ord7', (select SUM("basePrice") from "products" where "id" in (29, 4, 17, 58, 77)), 'on-progress', 'Jl. Surya Kencana No. 34, Semarang', 'Putri Kusuma', 'putri.kusuma2@gmail.com');

insert into "orderDetails" ("productId", "productVariantId", "productSizeId", "quantity", "orderId")
values (29, 1, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord7')),
       (4, 2, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord7')),
       (17, 3, 3, 1, (select "id" from "orders" where "orderNumber" = 'ord7')),
       (58, 1, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord7')),
       (77, 2, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord7'));


insert into "orders" ("userId", "orderNumber", "total", "status", "deliveryAddress", "fullName", "email")
values (6, 'ord8', (select SUM("basePrice") from "products" where "id" in (20, 5, 52, 7, 15)), 'delivered', 'Jl. Pahlawan No. 56, Medan', 'Budi Setiawan', 'budi.setiawan2@gmail.com');

insert into "orderDetails" ("productId", "productVariantId", "productSizeId", "quantity", "orderId")
values (20, 1, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord8')),
       (5, 2, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord8')),
       (52, 3, 3, 1, (select "id" from "orders" where "orderNumber" = 'ord8')),
       (7, 1, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord8')),
       (15, 2, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord8'));


insert into "orders" ("userId", "orderNumber", "total", "status", "deliveryAddress", "fullName", "email")
values (7, 'ord9', (select SUM("basePrice") from "products" where "id" in (28, 9, 44, 33, 21)), 'ready-to-pick', null, 'Siti Rahmawati', 'siti.rahmawati@gmail.com');

insert into "orderDetails" ("productId", "productVariantId", "productSizeId", "quantity", "orderId")
values (28, 1, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord9')),
       (9, 2, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord9')),
       (44, 3, 3, 1, (select "id" from "orders" where "orderNumber" = 'ord9')),
       (33, 1, 2, 1, (select "id" from "orders" where "orderNumber" = 'ord9')),
       (21, 2, 1, 1, (select "id" from "orders" where "orderNumber" = 'ord9'));

--select
--    "o"."orderNumber",
--    "u"."fullName" as "customerName",
--    "o"."deliveryAddress",
--    "p"."name" as "productName",
--    "ps"."size",
--    "pv"."name" as "variant",
--    "od"."quantity",
--    "o"."status",
--    "od"."quantity" * ("p"."basePrice" + "ps"."additionalPrice" + "pv"."additionalPrice") as "totalPurchase",
--    "o"."taxAmount"
--from
--    "orders" "o"
--join "users" "u" on "o"."userId" = "u"."id"
--join "orderDetails" "od" on "o"."id" = "od"."orderId"
--join "products" "p" on "od"."productId" = "p"."id"
--join "productSize" "ps" on "od"."productSizeId" = "ps"."id"
--join "productVariant" "pv" on "od"."productVariantId" = "pv"."id";

