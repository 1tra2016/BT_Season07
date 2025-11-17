create schema bt_season07_kha1;
set search_path to bt_season07_kha1;

create table book (
    book_id serial primary key,
    title varchar(255),
    author varchar(100),
    genre varchar(50),
    price decimal(10,2),
    description text,
    created_at timestamp default current_timestamp
);
insert into book (title, author, genre, price, description)
values
    ('Dế Mèn Phiêu Lưu Ký', 'Tô Hoài', 'Thiếu nhi', 85000.00, 'Cuộc phiêu lưu kỳ thú của Dế Mèn.'),
    ('Tuổi Trẻ Đáng Giá Bao Nhiêu', 'Rosie Nguyễn', 'Kỹ năng sống', 99000.00, 'Lời nhắn gửi đến người trẻ về hành trình trưởng thành.'),
    ('Harry Potter và Hòn Đá Phù Thủy', 'J.K. Rowling', 'Fantasy', 120000.00, 'Phần đầu tiên trong loạt truyện Harry Potter.'),
    ('Đắc Nhân Tâm', 'Dale Carnegie', 'Tâm lý học', 105000.00, 'Bí quyết để thành công trong giao tiếp và cuộc sống.');

explain analyze select * from book where author = 'Tô Hoài' and genre = 'Thiếu nhi';
explain analyze select * from book where genre = 'Fantasy';

create index idx_book_author on book(author);
create index idx_book_genre on book(genre);

explain analyze select * from book where author = 'Tô Hoài' and genre = 'Thiếu nhi';
explain analyze select * from book where genre = 'Fantasy';

create index idx_book_genre_btree on book(genre);

explain analyze select * from book where to_tsvector('english', description) @@ to_tsquery('adventure');
--gin index cho title
create index idx_book_title_gin on book using gin(to_tsvector('english', title));
--gin index cho description
create index idx_book_description_gin on book using gin(to_tsvector('english', description));
explain analyze select * from book where genre = 'Fantasy';
explain analyze select * from book where to_tsvector('english', description) @@ to_tsquery('adventure');

explain analyze select * from book where genre = 'Fantasy';
cluster book using idx_book_genre;
explain analyze select * from book where genre = 'Fantasy';

-- Chỉ mục B-tree là hiệu quả nhất cho các truy vấn lọc theo giá trị, sắp xếp, hoặc so sánh
-- Chỉ mục GIN phù hợp với tìm kiếm văn trên các cột kiểu text, truy vấn nhanh hơn like
-- Chỉ mục BRIN thích hợp cho các bảng lớn có dữ liệu phân bố tuần tự, như theo thời gian
-- Chỉ mục HASH tuy có thể nhanh với truy vấn bằng dấu bằng nhưng không hỗ trợ các phép so sánh khác, không truy vấn phức tạp như ORDER BY, JOIN
