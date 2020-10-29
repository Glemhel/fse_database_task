/*
======
US-201. READ Check if the student has access to the given survey. 
======

Given student_id and survey_id, find it in can_papticipate_in
*/

-- False
SELECT EXISTS(SELECT * FROM participated WHERE survey_id=2 AND student_id=3);

/*
======
US-101. READ Check if PTD has access to the given survey.
======

Given the staff_id and survey_id, determine 
whether he/she have access to this survey
*/

-- False
SELECT EXISTS(
  SELECT * 
  FROM survey AS s
    INNER JOIN 
    works_for AS w
    ON s.course_id=w.course_id
  WHERE staff_id=2 AND id=2
);

-- True
SELECT EXISTS(
  SELECT * 
  FROM survey AS s
    INNER JOIN 
    works_for AS w
    ON s.course_id=w.course_id
  WHERE staff_id=1 AND id=2
);


/*
======
US-113. READ Set time frames for form, s.t. form will not be available for students after the deadline
======

Given survey_id, check whether the current 
date is available for this survey

*/

-- False
SELECT EXISTS(SELECT FROM survey WHERE id=4 AND deadline > current_timestamp AND current_timestamp > pub_date);

-- True
SELECT EXISTS(SELECT FROM survey WHERE id=2 AND deadline > current_timestamp AND current_timestamp > pub_date);


/*
=======
US-210. UPDATE 
======

update one of student’s options as they wish given answer_id
*/

UPDATE answer SET data='bad' WHERE id=1;

/*
======
US-201. READ 
======

Given studen_id, check if they already participated
through a PARTICIPATED relation.
*/

SELECT survey_id FROM participated WHERE student_id=4;

/*
==============
US-121, US-211. DELETE
==============

cancel creation of a form, delete from answers by id.
*/

DELETE FROM answer WHERE id=8;

/*
======
US-301. DELETE 
======

delete staff account by email.
*/

DELETE FROM works_for WHERE staff_id=(SELECT id FROM staff WHERE email='n.kudasov@innopolis.ru');
DELETE FROM staff WHERE email='n.kudasov@innopolis.ru';


/*
======
US-130. READ 
======

Give all the answers for the given survey_id
*/

SELECT * FROM answer WHERE question_id IN (SELECT number_in_survey FROM question WHERE survey_id=1) ORDER BY question_id;

/*
======
US-130. READ
======

Give all answers for the given course
*/
SELECT ans.id AS answer_id, ans.data, text as question_text, short_name as survey_short_name
FROM answer AS ans
  INNER JOIN 
  question AS q 
  ON ans.question_id=q.id 
  
  INNER JOIN
  survey AS s 
  ON q.survey_id=s.id

WHERE course_id=4
;


/*
=======
US-110. CREATE 
=======

Create new survey with data given
*/

INSERT INTO survey (short_name, deadline, pub_date, course_id) VALUES ('New survey name', current_timestamp, current_timestamp + interval '1 day', 1);
INSERT INTO question (type, is_mandatory, number_in_survey, text, data, survey_id)
  VALUES
  (1, true, 1, 'How do you feel?', 'good;bad;fifty-fifty', (SELECT id FROM survey ORDER BY id DESC LIMIT 1)),
  (1, true, 2, 'Do you want to kek', 'yes;no', (SELECT id FROM survey ORDER BY id DESC LIMIT 1)),
  (0, false, 3, 'Say lol', '', (SELECT id FROM survey ORDER BY id DESC LIMIT 1))
;
