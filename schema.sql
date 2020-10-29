CREATE TABLE staff (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  is_superuser BOOLEAN DEFAULT false,
  is_ta BOOLEAN DEFAULT false,
  is_prof BOOLEAN DEFAULT false,
  is_doe BOOLEAN DEFAULT false
);

CREATE TABLE subject (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  is_elective BOOLEAN DEFAULT false
);

CREATE TABLE course (
  id SERIAL PRIMARY KEY,
  year VARCHAR(2) NOT NULL,
  degree VARCHAR(2) NOT NULL,
  subject_id INT NOT NULL,
  FOREIGN KEY (subject_id) REFERENCES subject(id)
);

CREATE TABLE survey (
  id SERIAL PRIMARY KEY,
  short_name VARCHAR(255) NOT NULL,
  deadline TIMESTAMP NOT NULL,
  pub_date TIMESTAMP NOT NULL,
  course_id INT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES course(id)
);

CREATE TABLE student (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL
);


CREATE TABLE question (
  id SERIAL PRIMARY KEY,
  type int NOT NULL,
  is_mandatory BOOLEAN DEFAULT false,
  number_in_survey int NOT NULL,
  text VARCHAR(255) NOT NULL,
  data VARCHAR(500) NOT NULL,
  survey_id INT NOT NULL,
  FOREIGN KEY (survey_id) REFERENCES survey(id)
);

CREATE TABLE answer (
  id SERIAL PRIMARY KEY,
  question_id INT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES question(id),
  data VARCHAR(1000) NOT NULL
);

CREATE TABLE tracks (
    course_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(id),
    track_name VARCHAR(255) NOT NULL
);

CREATE TABLE participated (
    student_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(id),

    survey_id INT NOT NULL,
    FOREIGN KEY (survey_id) REFERENCES survey(id)
);

CREATE TABLE studies_at (
    student_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(id),

    course_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(id)
);

CREATE TABLE works_for (
    staff_id INT NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(id),

    course_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES course(id)
);



/*
  =============
  INSERT VALUES
  =============
*/

INSERT INTO staff (email, first_name, last_name, is_ta, is_prof, is_doe)
VALUES
('e.bobrov@innopolis.ru', 'Evgenii', 'Bobrov', false, true, true),
('p.kolychev@innopolis.ru', 'Pavel', 'Kolychev', true, false, false),
('n.askarbekuly@innopolis.ru', 'Nursultan', 'Askarbekuly', true, false, false),
('n.kudasov@innopolis.ru', 'Nickolay', 'Kudasov', true, true, false),
('a.burmyakov@innopolis.ru', 'Artem', 'Burmyakov', true, true, false);

INSERT INTO subject (title, description) VALUES ('MA', 'Mathematical Analysis');
INSERT INTO subject (title, description) VALUES ('DE', 'Differential Equations');
INSERT INTO subject (title, description) VALUES ('ML', 'Machine Learning');
INSERT INTO subject (title, description) VALUES ('PS', 'Probability and Statistics');
INSERT INTO subject (title, description, is_elective) VALUES ('RE', 'Reverse Engeneering', true);

INSERT INTO course (year, degree, subject_id) VALUES ('20', 'BS', 1);
INSERT INTO course (year, degree, subject_id) VALUES ('19', 'MS', 3);
INSERT INTO course (year, degree, subject_id) VALUES ('18', 'BS', 2);
INSERT INTO course (year, degree, subject_id) VALUES ('17', 'BS', 4);
INSERT INTO course (year, degree, subject_id) VALUES ('16', 'MS', 5);

INSERT INTO student (email, first_name, last_name)
VALUES
('m.rudakov@innopolis.university', 'Mikhail', 'Rudakov'),
('p.minina@innopolis.university', 'Polina', 'Minina'),
('l.lymarenko@innopolis.university', 'Lev', 'Lymarenko'),
('h.vechtomov@innopolis.university', 'German', 'Vechmotov'),
('d.shabalin@innopolis.university', 'Dmitrii', 'Shabalin');


INSERT INTO survey (short_name, deadline, pub_date, course_id)
VALUES
('Midterm Feeback', '2020-11-19 23:00:00','2020-10-10 09:00:00', 1),
('Lecture suggestions', '2020-10-30 23:59:59','2020-10-28 11:00:00', 2),
('Weekly Lab Feedback', '2020-11-1 17:00:00','2020-10-25 18:05:00', 3),
('End-of-semester courses feedback', '2020-12-1 23:59:59', '2020-11-25 12:00:00', 4),
('Weekly questionnary', '2020-11-12 23:59:59', '2020-10-23 10:00:00', 5);
/*
0 - open question
1 - closed question, single select
2 - closed, multi select
3 - interval scale question
*/
INSERT INTO question (type, is_mandatory, number_in_survey, text, data, survey_id)
VALUES
(1, true, 1, 'How do you feel about your Midterm?', 'good;bad;fifty-fifty', 1),
(1, true, 2, 'Do you want to retake it?', 'yes;no', 1),
(0, false, 3, 'Express your emotions about Midterm', '', 1),

(1, true, 1, 'Did you find material in lecture useful?', 'yes;no;at least half of it was useful', 2),
(3, true, 2, 'How much material did you understand from the lecture?', '0;100', 2),
(2, true, 3, 'Express your emotions about lecture today?', 'angry;succi;happy;tired;upset;sad;harry potter', 2),
(0, false, 4, 'Any further suggestions about the lectures?', '', 2),

(1, true, 1, 'Did you attend the lab?', 'yes;no', 3),
(0, true, 2, 'Please write your feedback on lab improvement', '', 3),

(1, true, 1, 'What is your level of satisfaction with your results?', 'excellent;good;fine;bad;awful;drop', 4),
(2, true, 2, 'Select your favourite subjects this semester', 'MA;PS;FSE;PH;DE;RE', 4),
(1, true, 3, 'Select your least favourite subject this semester', 'MA;PS;FSE;PH;DE;RE', 4),
(0, false, 4, 'Please suggest improvements about least favourite subject', '', 4),
(0, false, 5, 'Any more feedback is welcome', '', 4),

(2, true, 1, 'How are your doing this week in your studies?', 'well;bad;drink red bull; sleep 8 hours every day', 5);

INSERT INTO answer (question_id, data)
VALUES
(1, 'good'), (1, 'bad'), (1, 'bad'),
(2, 'yes'), (2, 'yes'), (2, 'yes'),
(3, 'It was really hard'), (3, 'It was pretty easy but Im stupid'),

(4, 'yes'), (4, 'no'), (4, 'at least half of it was useful'), (4, 'at least half of it was useful'),
(5, '64'), (5, '0'), (5, '15'), (5, '99'),
(6, 'angry;succi;sad'), (6, 'sad;harry potter'), (6, 'happy;tired;harry potter;sad'),
(7, 'Shift lecture to 1pm'), (7, 'Please stop it'),

(8, 'yes'), (8, 'no'), (8, 'no'), (8, 'yes'),
(9, 'delete it'), (9, 'more explanatoin'), (9, 'easier tasks please'), (9, 'all is fine'),

(10, 'excellent'), (10, 'excellent'), (10, 'drop'),(10, 'fine'),
(11, 'MA;PS'), (11, 'DE;PS'), (11, 'PH;RE'), (11, 'FSE;DE'),
(12, 'FSE'), (12, 'FSE'), (12, 'FSE'), (12, 'PS'),
(13, 'Clearer tasks'), (13, 'Return Kudasov pls'),
(14, 'Your app is good!');

INSERT INTO tracks (course_id, track_name)
VALUES (1, 'BS'), (1, 'MS'), (2, 'BS'), (3, 'BS'), (4, 'BS'), (5, 'BS'),
(5, 'MS');

INSERT INTO participated (student_id, survey_id)
VALUES
(1, 1), (2, 3), (3, 1), (3, 2), (4, 1), (4, 5), (5, 2);

INSERT INTO studies_at (student_id, course_id)
VALUES
(1, 1), (1, 2), (1, 4), (2, 3), (2, 5), (3, 1), (3, 2), (3, 4),
(4, 1), (4, 2), (4, 3), (4, 5), (5, 2), (5, 5);

INSERT INTO works_for (staff_id, course_id)
VALUES (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (2, 1), (2, 3), (2, 4),
(3, 1), (3, 4), (4, 2), (4, 3), (4, 4), (5, 1), (5, 3), (5, 5);
