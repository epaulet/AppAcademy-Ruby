DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(50) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,


  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Edward', 'Paulet'), ('Daniel', 'Lacis'), ('CJ', 'Avilla'),
  ('Ned', 'Ruggeri'), ('David', 'Awesome');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('Do you want to build a snowman?',
     'Do you wanna build a snowman? Come on lets go and play', 3),
     ('Hello?', 'Is anyone there?', 4),
     ('Umm', 'Where did I park my car?', 5),
     ('What is a select?', 'Seriously, does anyone know?', 1),
     ('Wheres the snow?', 'I REALLY need to build a snowman.', 3),
     ('What?', 'What what what', 2);

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 1, 'Okay, bye.'), (1, 1, 2, 'What are you talking about?'),
  (3, NULL, 2, 'You have a car?'), (3, 3, 5, 'Oh right...'),
  (3, 3, 1, 'Thats what I was going to say.'), (5, NULL, 4, 'Lake Tahoe');

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 1), (5, 1), (4, 1), (1, 2), (2, 2), (3, 2), (4, 2), (5, 2),
  (1, 3), (4, 3), (2, 4);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (2, 1), (1, 1), (5, 1), (4, 1), (1, 2), (2, 2), (3, 2);
