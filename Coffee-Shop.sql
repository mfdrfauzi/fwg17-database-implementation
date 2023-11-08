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
"taxAmount" numeric(12,2) generated always as (total * 0.10) stored,
"status" "orderStatus" not null,
"deliveryAddress" text not null,
"fullName" varchar(30) not null,
"email" varchar(30) not null,
"created_at" timestamp default now(),
"updated_at" timestamp
);

create table if not exists "orderDetails" (
"id" serial primary key,
"produtId" int references "products"("id"),
"produtSizeId" int references "productSize"("id"),
"produtVariantId" int references "productVariant"("id"),
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
	
