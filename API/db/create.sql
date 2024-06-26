CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    username TEXT NOT NULL,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_at INTEGER(4) NOT NULL DEFAULT (unixepoch('now')),
    updated_at INTEGER(4) NOT NULL DEFAULT (unixepoch('now')),

    CONSTRAINT user_name_length CHECK (length(username) > 2 AND length(username) <= 128),
    CONSTRAINT user_username_length CHECK (length(username) >= 4 AND length(username) <= 16),
    CONSTRAINT user_email_length CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT user_password_length CHECK (length(password) == 60)
);

CREATE TABLE refresh_token (
    id TEXT PRIMARY KEY,
    jwt_id TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    expires_at INTEGER(4) NOT NULL,
    created_at INTEGER(4) NOT NULL DEFAULT (unixepoch('now')),
    updated_at INTEGER(4) NOT NULL DEFAULT (unixepoch('now')),

    CONSTRAINT refreshToken_jwtId_unique UNIQUE (jwt_id),
    CONSTRAINT refreshToken_userId_fk FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE INDEX refreshToken_jwtId_idx ON refresh_token(jwt_id);
CREATE INDEX refreshToken_userId_idx ON refresh_token(user_id);

CREATE TABLE task (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at INTEGER(4) NOT NULL DEFAULT (unixepoch('now')),
    updated_at INTEGER(4) NOT NULL DEFAULT (unixepoch('now')),

    CONSTRAINT task_name_length CHECK (length(name) > 4 AND length(name) <= 256),
    CONSTRAINT task_userId_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

CREATE INDEX tasks_userId_idx ON task(user_id);

INSERT INTO user (name, username, email, password, is_active)
VALUES ('Svego Admin', 'svego', 'internal@svego.com', '$2a$12$0xVpHFQBlk0BWzBxv7Ubsuqg/sYBhzNuYYyM563dGfzIl4ssue9LG',
        true)