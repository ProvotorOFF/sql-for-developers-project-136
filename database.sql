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
    video_url varchar(255),
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
    price decimal(10, 2),
    program_type varchar(20),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table course_modules (
    course_id bigint references courses(id) not null,
    module_id bigint references modules(id) not null,
    primary key (course_id, module_id)
);

create table program_modules (
    program_id bigint references programs(id) not null,
    module_id bigint references modules(id) not null,
    primary key (program_id, module_id)
);

create table teaching_groups (
    id bigint generated always as identity primary key,
    slug varchar(20) not null,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table users (
    id bigint generated always as identity primary key,
    name varchar(255) not null,
    email varchar(255) unique not null,
    password_hash varchar(255),
    teaching_group_id bigint references teaching_groups(id),
    role varchar(20) check(role in ('Student', 'Teacher', 'Admin')),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null,
    deleted_at timestamp
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
    amount decimal(10, 2) not null,
    status varchar(30) check(
        status in ('pending', 'paid', 'failed', 'refunded')
    ),
    paid_at timestamp default now() not null,
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
    started_at timestamp default now() not null,
    completed_at timestamp default now(),
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

create table quizzes (
    id bigint generated always as identity primary key,
    lesson_id bigint references lessons(id),
    name varchar(255),
    content jsonb,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table exercises (
    id bigint generated always as identity primary key,
    lesson_id bigint references lessons(id),
    name varchar(255),
    url varchar(255) unique not null,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table discussions (
    id bigint generated always as identity primary key,
    user_id bigint references users(id),
    lesson_id bigint references lessons(id),
    text jsonb,
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);

create table blogs (
    id bigint generated always as identity primary key,
    user_id bigint references users(id),
    name varchar(255) not null,
    content text,
    status varchar(30) check(
        status in (
            'created',
            'in moderation',
            'published',
            'archived'
        )
    ),
    created_at timestamp default now() not null,
    updated_at timestamp default now() not null
);