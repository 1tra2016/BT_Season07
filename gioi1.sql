create schema bt_season07_gioi1;
set search_path to bt_season07_gioi1;

create table post (
    post_id serial primary key,
    user_id int not null,
    content text,
    tags text[],
    created_at timestamp default current_timestamp,
    is_public boolean default true
);

create table post_like (
    user_id int not null,
    post_id int not null,
    liked_at timestamp default current_timestamp,
    primary key (user_id, post_id)
);
-- Thêm bài viết
insert into post (user_id, content, tags, is_public) values
    (1, 'Hôm nay trời đẹp quá!', array['life', 'weather'], true),
    (2, 'Đã hoàn thành bài tập SQL!', array['study', 'sql'], true),
    (3, 'Bí mật không muốn chia sẻ', array['private'], false);

-- Thêm lượt thích
insert into post_like (user_id, post_id) values
    (2, 1),
    (1, 2),
    (3, 2);

explain analyze select post_id, content from post where is_public = true and content ilike '%trời%';
create index idx_post_lower_content on post (lower(content));
explain analyze select post_id, content from post where is_public = true and content ilike '%trời%';
--không đáng kể, chắc do số lượng ít quá

explain analyze select * from post where tags && array['life', 'weather'];
create index idx_post_tags_gin on post using gin (tags);
explain analyze select * from post where tags && array['life', 'weather'];
-- nhanh gấp đôi

create index idx_post_recent_public
on post(created_at desc)
where is_public = true;
select * from post where is_public = true and created_at >= now() - interval '7 day';

explain analyze select post_id, content, created_at
from post
order by created_at desc
limit 10;
create index idx_post_user_created_at on post (user_id, created_at desc);
explain analyze select post_id, content, created_at
from post
order by created_at desc
limit 10;
-- không đnags kể