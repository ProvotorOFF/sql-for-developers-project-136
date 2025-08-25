create table courses (
    id bigint generated always as identity primary key,
    name varchar(255) not null,
    description text,
    created_at timestamp default now() not null,
    updated_at timestamp default current_timestamp not null,
    deleted_at timestamp default null
);

create table lessons (
    id bigint generated always as identity primary key,
    name varchar(255) not null,
    content text,
    link varchar(255),
    position int,
    course_id bigint references courses(id),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null,
    deleted_at timestamp default null
);

create table modules (
    id bigint generated always as identity primary key,
    name varchar(255) not null,
    description text,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null,
    deleted_at timestamp default null
);

create table programs (
    id bigint generated always as identity primary key,
    name varchar(255) not null,
    cost decimal(10, 2),
    type varchar(20),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table courses_modules (
    course_id bigint references courses(id) not null,
    module_id bigint references modules(id) not null,
    primary key (course_id, module_id)
);

create table programs_modules(
    program_id bigint references programs(id) not null,
    module_id bigint references modules(id) not null
);

create table teaching_groups (
    id bigint generated always as identity primary key,
    name varchar(20) check(name in ('student', 'teacher', 'admin')),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table users (
    id bigint generated always as identity primary key,
    name varchar(255) not null,
    email varchar(255) unique not null,
    password varchar(255) not null,
    teaching_group_id bigint references teaching_groups(id) not null,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table enrollments (
    id bigint generated always as identity primary key,
    user_id bigint references users(id) not null,
    program_id bigint references programs(id) not null,
    status varchar(30) check(
        status in ('active', 'pending', 'cancelled', 'completed')
    ),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table payments (
    id bigint generated always as identity primary key,
    enrollment_id bigint references enrollments(id) not null,
    sum decimal(10, 2) not null,
    status varchar(30) check(
        status in ('pending', 'paid', 'failed', 'refunded')
    ),
    payed_at timestamp default now() not null,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table program_completions (
    id bigint generated always as identity primary key,
    user_id bigint references users(id) not null,
    program_id bigint references programs(id) not null,
    status varchar(30) check(
        status in ('active', 'completed', 'pending', 'cancelled')
    ),
    date_start timestamp default now() not null,
    date_end timestamp default now(),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table certificates (
    id bigint generated always as identity primary key,
    user_id bigint references users(id) not null,
    program_id bigint references programs(id) not null,
    url varchar(255) unique not null,
    issued_at timestamp default now() not null,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);