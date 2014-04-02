DROP TABLE users;
CREATE TABLE `users` (
   `id` integer NOT NULL primary key AUTOINCREMENT,
   `name` text,
   `email` text,
   `created_at` datetime,
   `updated_at` datetime
);
