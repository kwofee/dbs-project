
-- Drop existing tables (in reverse order of dependencies)
DROP TABLE IF EXISTS works_on;
DROP TABLE IF EXISTS funded_by;
DROP TABLE IF EXISTS student_project;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS subsystem;


-- create queries

CREATE TABLE department (
    dept_name VARCHAR(100) PRIMARY KEY,
    budget DECIMAL(10,2) NOT NULL
);
CREATE TABLE faculty (
    ID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);
CREATE TABLE student (
    registration_number INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL
);
CREATE TABLE student_project (
    studproj_name VARCHAR(100) PRIMARY KEY,
    dept_name VARCHAR(100),
    advisor INT UNIQUE, -- Ensuring one faculty advises only one project
    FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE SET NULL,
    FOREIGN KEY (advisor) REFERENCES faculty(ID) ON DELETE SET NULL
);

CREATE TABLE subsystem (
    subsystem_name VARCHAR(100),
    studproj_name VARCHAR(100),
    leader_regno INT,  -- Match data type with student.registration_number
    
    PRIMARY KEY (subsystem_name, studproj_name),
    FOREIGN KEY (studproj_name) REFERENCES student_project(studproj_name),
    FOREIGN KEY (leader_regno) REFERENCES student(registration_number)
    );

CREATE TABLE works_on (
    registration_number INT,
    studproj_name VARCHAR(100),
    PRIMARY KEY (registration_number, studproj_name),
    FOREIGN KEY (registration_number) REFERENCES student(registration_number) ON DELETE CASCADE,
    FOREIGN KEY (studproj_name) REFERENCES student_project(studproj_name) ON DELETE CASCADE
);
CREATE TABLE funded_by (
    studproj_name VARCHAR(100) PRIMARY KEY,
    dept_name VARCHAR(100),
    FOREIGN KEY (studproj_name) REFERENCES student_project(studproj_name) ON DELETE CASCADE,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE CASCADE
);


CREATE TABLE fund_request (
         req_id INT PRIMARY KEY AUTO_INCREMENT,
         student_id INT,
         project_name VARCHAR(255),
         amount DECIMAL(10, 2),
         status VARCHAR(20) DEFAULT 'pending',
         department VARCHAR(100),
         request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         FOREIGN KEY (student_id) REFERENCES student(registration_number)
     );

-- Insert into department
INSERT INTO department (dept_name, budget) VALUES
('Mechanical Engineering', 5000000.00),
('Mechatronics', 3000000.00),
('Computer Science', 7000000.00),
('Aeronautical and Automobile Engineering', 4000000.00),
('Electronics and Communication Engineering', 4500000.00),
('Biotechnology', 2500000.00),
('Electronics and Instrumentation Engineering', 3500000.00),
('Aeronautical Engineering', 3800000.00);

-- Insert into faculty
INSERT INTO faculty (ID, name, dept_name, email) VALUES
(101, 'Dr. Rajesh Verma', 'Mechanical Engineering', 'rajesh.verma@example.com'),
(102, 'Dr. Ananya Iyer', 'Mechatronics', 'ananya.iyer@example.com'),
(103, 'Dr. Sameer Ghosh', 'Computer Science', 'sameer.ghosh@example.com'),
(104, 'Dr. Vishal Nair', 'Mechanical Engineering', 'vishal.nair@example.com'),
(105, 'Dr. Meera Reddy', 'Mechanical Engineering', 'meera.reddy@example.com'),
(106, 'Dr. Piyush Sharma', 'Mechanical Engineering', 'piyush.sharma@example.com'),
(107, 'Dr. Swati Menon', 'Mechanical Engineering', 'swati.menon@example.com'),
(108, 'Dr. Alok Trivedi', 'Aeronautical and Automobile Engineering', 'alok.trivedi@example.com'),
(109, 'Dr. Radhika Joshi', 'Electronics and Communication Engineering', 'radhika.joshi@example.com'),
(110, 'Dr. Neeraj Saxena', 'Aeronautical and Automobile Engineering', 'neeraj.saxena@example.com'),
(111, 'Dr. Sanya Kapoor', 'Electronics and Communication Engineering', 'sanya.kapoor@example.com'),
(112, 'Dr. Aman Bansal', 'Mechatronics', 'aman.bansal@example.com'),
(113, 'Dr. Shruti Deshmukh', 'Biotechnology', 'shruti.deshmukh@example.com'),
(114, 'Dr. Dhruv Malhotra', 'Electronics and Instrumentation Engineering', 'dhruv.malhotra@example.com'),
(115, 'Dr. Kavita Pillai', 'Aeronautical Engineering', 'kavita.pillai@example.com'),
(116, 'Dr. Karan Sinha', 'Mechanical Engineering', 'karan.sinha@example.com'),
(117, 'Dr. Priya Chatterjee', 'Computer Science', 'priya.chatterjee@example.com'),
(118, 'Dr. Arvind Mehta', 'Aeronautical Engineering', 'arvind.mehta@example.com'),
(119, 'Dr. Yuvraj Khanna', 'Mechanical Engineering', 'yuvraj.khanna@example.com'),
(120, 'Dr. Nisha Desai', 'Electronics and Communication Engineering', 'nisha.desai@example.com');

-- INSERT INTO student

INSERT INTO student (registration_number, name, dept_name, email) VALUES
-- Mechanical Engineering Students
(201, 'Aarav Sharma', 'Mechanical Engineering', 'aarav.sharma@example.com'),
(202, 'Vivaan Patel', 'Mechanical Engineering', 'vivaan.patel@example.com'),
(203, 'Kabir Verma', 'Mechanical Engineering', 'kabir.verma@example.com'),
(204, 'Aryan Joshi', 'Mechanical Engineering', 'aryan.joshi@example.com'),
(205, 'Devang Mehta', 'Mechanical Engineering', 'devang.mehta@example.com'),
(206, 'Ishaan Malhotra', 'Mechanical Engineering', 'ishaan.malhotra@example.com'),
(207, 'Rudra Nair', 'Mechanical Engineering', 'rudra.nair@example.com'),
(208, 'Rohan Iyer', 'Mechanical Engineering', 'rohan.iyer@example.com'),
(209, 'Ayaan Saxena', 'Mechanical Engineering', 'ayaan.saxena@example.com'),
(210, 'Aditya Kapoor', 'Mechanical Engineering', 'aditya.kapoor@example.com'),

(211, 'Ritika Choudhary', 'Mechatronics', 'ritika.choudhary@example.com'),
(212, 'Sneha Kothari', 'Mechatronics', 'sneha.kothari@example.com'),
(213, 'Neha Agarwal', 'Mechatronics', 'neha.agarwal@example.com'),
(214, 'Arjun Tiwari', 'Mechatronics', 'arjun.tiwari@example.com'),
(215, 'Siddharth Roy', 'Mechatronics', 'siddharth.roy@example.com'),
(216, 'Pranav Sinha', 'Mechatronics', 'pranav.sinha@example.com'),
(217, 'Krishna Nambiar', 'Mechatronics', 'krishna.nambiar@example.com'),
(218, 'Rishi Bhattacharya', 'Mechatronics', 'rishi.bhattacharya@example.com'),
(219, 'Nikhil Rao', 'Mechatronics', 'nikhil.rao@example.com'),
(220, 'Tushar Pillai', 'Mechatronics', 'tushar.pillai@example.com'),

-- Computer Science Students
(221, 'Aditi Menon', 'Computer Science', 'aditi.menon@example.com'),
(222, 'Varun Bansal', 'Computer Science', 'varun.bansal@example.com'),
(223, 'Kunal Thakur', 'Computer Science', 'kunal.thakur@example.com'),
(224, 'Rajeev Kulkarni', 'Computer Science', 'rajeev.kulkarni@example.com'),
(225, 'Meera Ghosh', 'Computer Science', 'meera.ghosh@example.com'),
(226, 'Shivangi Mishra', 'Computer Science', 'shivangi.mishra@example.com'),
(227, 'Yashvardhan Sharma', 'Computer Science', 'yashvardhan.sharma@example.com'),
(228, 'Ankita Deshmukh', 'Computer Science', 'ankita.deshmukh@example.com'),
(229, 'Rishabh Jain', 'Computer Science', 'rishabh.jain@example.com'),
(230, 'Harsh Vardhan', 'Computer Science', 'harsh.vardhan@example.com'),

-- Aeronautical and Automobile Engineering
(271, 'Raghav Arora', 'Aeronautical and Automobile Engineering', 'raghav.arora@example.com'),
(272, 'Pooja Iyer', 'Aeronautical and Automobile Engineering', 'pooja.iyer@example.com'),
(273, 'Aakash Sethi', 'Aeronautical and Automobile Engineering', 'aakash.sethi@example.com'),
(274, 'Tanvi Bhatia', 'Aeronautical and Automobile Engineering', 'tanvi.bhatia@example.com'),
(275, 'Rhea Chatterjee', 'Aeronautical and Automobile Engineering', 'rhea.chatterjee@example.com'),
(276, 'Dhruv Saxena', 'Aeronautical and Automobile Engineering', 'dhruv.saxena@example.com'),
(277, 'Bhavana Kapoor', 'Aeronautical and Automobile Engineering', 'bhavana.kapoor@example.com'),
(278, 'Aryan Khanna', 'Aeronautical and Automobile Engineering', 'aryan.khanna@example.com'),
(279, 'Mihir Trivedi', 'Aeronautical and Automobile Engineering', 'mihir.trivedi@example.com'),
(280, 'Isha Malhotra', 'Aeronautical and Automobile Engineering', 'isha.malhotra@example.com'),

-- Electronics and Communication Engineering
(281, 'Sanjay Desai', 'Electronics and Communication Engineering', 'sanjay.desai@example.com'),
(282, 'Aishwarya Verma', 'Electronics and Communication Engineering', 'aishwarya.verma@example.com'),
(283, 'Kritika Dutta', 'Electronics and Communication Engineering', 'kritika.dutta@example.com'),
(284, 'Omkar Kulkarni', 'Electronics and Communication Engineering', 'omkar.kulkarni@example.com'),
(285, 'Ramesh Reddy', 'Electronics and Communication Engineering', 'ramesh.reddy@example.com'),
(286, 'Nidhi Mishra', 'Electronics and Communication Engineering', 'nidhi.mishra@example.com'),
(287, 'Gautam Nair', 'Electronics and Communication Engineering', 'gautam.nair@example.com'),
(288, 'Priyanshu Mehta', 'Electronics and Communication Engineering', 'priyanshu.mehta@example.com'),
(289, 'Vivek Sharma', 'Electronics and Communication Engineering', 'vivek.sharma@example.com'),
(290, 'Shruti Agarwal', 'Electronics and Communication Engineering', 'shruti.agarwal@example.com'),

-- Biotechnology
(321, 'Kavya Deshmukh', 'Biotechnology', 'kavya.deshmukh@example.com'),
(322, 'Ananya Ghosh', 'Biotechnology', 'ananya.ghosh@example.com'),
(323, 'Suraj Jadhav', 'Biotechnology', 'suraj.jadhav@example.com'),
(324, 'Mitali Sinha', 'Biotechnology', 'mitali.sinha@example.com'),
(325, 'Siddharth Malhotra', 'Biotechnology', 'siddharth.malhotra@example.com'),
(326, 'Tara Iyer', 'Biotechnology', 'tara.iyer@example.com'),
(327, 'Jayant Pillai', 'Biotechnology', 'jayant.pillai@example.com'),
(328, 'Rohan Kulkarni', 'Biotechnology', 'rohan.kulkarni@example.com'),
(329, 'Pallavi Rao', 'Biotechnology', 'pallavi.rao@example.com'),
(330, 'Nishant Kapoor', 'Biotechnology', 'nishant.kapoor@example.com');



INSERT INTO student (registration_number, name, dept_name, email) VALUES
-- More Mechanical Engineering Students
(401, 'Raj Malhotra', 'Mechanical Engineering', 'raj.malhotra@example.com'),
(402, 'Tanishq Mehta', 'Mechanical Engineering', 'tanishq.mehta@example.com'),
(403, 'Ishita Sharma', 'Mechanical Engineering', 'ishita.sharma@example.com'),
(404, 'Yuvraj Joshi', 'Mechanical Engineering', 'yuvraj.joshi@example.com'),
(405, 'Harshit Nair', 'Mechanical Engineering', 'harshit.nair@example.com'),

-- More Mechatronics Students
(406, 'Vedant Bhargava', 'Mechatronics', 'vedant.bhargava@example.com'),
(407, 'Anaya Desai', 'Mechatronics', 'anaya.desai@example.com'),
(408, 'Ritvik Kapoor', 'Mechatronics', 'ritvik.kapoor@example.com'),
(409, 'Sanya Tiwari', 'Mechatronics', 'sanya.tiwari@example.com'),
(410, 'Kushagra Iyer', 'Mechatronics', 'kushagra.iyer@example.com'),

-- More Computer Science Students
(411, 'Samar Goyal', 'Computer Science', 'samar.goyal@example.com'),
(412, 'Saanvi Sinha', 'Computer Science', 'saanvi.sinha@example.com'),
(413, 'Daksh Trivedi', 'Computer Science', 'daksh.trivedi@example.com'),
(414, 'Aarohi Khanna', 'Computer Science', 'aarohi.khanna@example.com'),
(415, 'Reyansh Patel', 'Computer Science', 'reyansh.patel@example.com'),

-- More Electronics and Communication Engineering Students
(416, 'Aisha Verma', 'Electronics and Communication Engineering', 'aisha.verma@example.com'),
(417, 'Pratyush Sharma', 'Electronics and Communication Engineering', 'pratyush.sharma@example.com'),
(418, 'Zara Bhattacharya', 'Electronics and Communication Engineering', 'zara.bhattacharya@example.com'),
(419, 'Dhruv Reddy', 'Electronics and Communication Engineering', 'dhruv.reddy@example.com'),
(420, 'Avni Saxena', 'Electronics and Communication Engineering', 'avni.saxena@example.com'),

-- More Biotechnology Students
(421, 'Arnav Menon', 'Biotechnology', 'arnav.menon@example.com'),
(422, 'Vanya Nambiar', 'Biotechnology', 'vanya.nambiar@example.com'),
(423, 'Aayush Pillai', 'Biotechnology', 'aayush.pillai@example.com'),
(424, 'Tara Bansal', 'Biotechnology', 'tara.bansal@example.com'),
(425, 'Shaurya Deshmukh', 'Biotechnology', 'shaurya.deshmukh@example.com'),

-- More Aeronautical and Automobile Engineering Students
(426, 'Ahaan Kulkarni', 'Aeronautical and Automobile Engineering', 'ahaan.kulkarni@example.com'),
(427, 'Mira Choudhary', 'Aeronautical and Automobile Engineering', 'mira.choudhary@example.com'),
(428, 'Eshan Gupta', 'Aeronautical and Automobile Engineering', 'eshan.gupta@example.com'),
(429, 'Ishani Tiwari', 'Aeronautical and Automobile Engineering', 'ishani.tiwari@example.com'),
(430, 'Krish Agarwal', 'Aeronautical and Automobile Engineering', 'krish.agarwal@example.com'),

-- More students across all departments
(431, 'Atharv Malhotra', 'Mechanical Engineering', 'atharv.malhotra@example.com'),
(432, 'Shreya Kapoor', 'Computer Science', 'shreya.kapoor@example.com'),
(433, 'Nishant Reddy', 'Mechatronics', 'nishant.reddy@example.com'),
(434, 'Jiya Nair', 'Electronics and Communication Engineering', 'jiya.nair@example.com'),
(435, 'Divyansh Trivedi', 'Aeronautical and Automobile Engineering', 'divyansh.trivedi@example.com'),
(436, 'Kiara Bhardwaj', 'Biotechnology', 'kiara.bhardwaj@example.com'),
(437, 'Shaurya Saxena', 'Mechanical Engineering', 'shaurya.saxena@example.com'),
(438, 'Kavya Gupta', 'Computer Science', 'kavya.gupta@example.com'),
(439, 'Pranay Sinha', 'Mechatronics', 'pranay.sinha@example.com'),
(440, 'Anshika Desai', 'Electronics and Communication Engineering', 'anshika.desai@example.com'),
(441, 'Aarush Sharma', 'Aeronautical and Automobile Engineering', 'aarush.sharma@example.com'),
(442, 'Myra Tiwari', 'Biotechnology', 'myra.tiwari@example.com'),
(443, 'Tanmay Mehta', 'Mechanical Engineering', 'tanmay.mehta@example.com'),
(444, 'Mehak Chatterjee', 'Computer Science', 'mehak.chatterjee@example.com'),
(445, 'Hardik Verma', 'Mechatronics', 'hardik.verma@example.com'),
(446, 'Avi Iyer', 'Electronics and Communication Engineering', 'avi.iyer@example.com'),
(447, 'Saanvika Menon', 'Aeronautical and Automobile Engineering', 'saanvika.menon@example.com'),
(448, 'Ayush Agarwal', 'Biotechnology', 'ayush.agarwal@example.com'),
(449, 'Ishaan Bansal', 'Mechanical Engineering', 'ishaan.bansal@example.com'),
(450, 'Riya Pillai', 'Computer Science', 'riya.pillai@example.com'),
(451, 'Harshit Khanna', 'Mechatronics', 'harshit.khanna@example.com'),
(452, 'Tisha Trivedi', 'Electronics and Communication Engineering', 'tisha.trivedi@example.com'),
(453, 'Aryan Reddy', 'Aeronautical and Automobile Engineering', 'aryan.reddy@example.com'),
(454, 'Jasmine Verma', 'Biotechnology', 'jasmine.verma@example.com'),
(455, 'Karan Malhotra', 'Mechanical Engineering', 'karan.malhotra@example.com'),
(456, 'Suhana Nambiar', 'Computer Science', 'suhana.nambiar@example.com'),
(457, 'Rohit Kapoor', 'Mechatronics', 'rohit.kapoor@example.com'),
(458, 'Esha Iyer', 'Electronics and Communication Engineering', 'esha.iyer@example.com'),
(459, 'Veer Sinha', 'Aeronautical and Automobile Engineering', 'veer.sinha@example.com'),
(460, 'Prisha Deshmukh', 'Biotechnology', 'prisha.deshmukh@example.com'),
(461, 'Vihaan Menon', 'Mechanical Engineering', 'vihaan.menon@example.com'),
(462, 'Aadhya Tiwari', 'Computer Science', 'aadhya.tiwari@example.com'),
(463, 'Advait Saxena', 'Mechatronics', 'advait.saxena@example.com'),
(464, 'Sanya Malhotra', 'Electronics and Communication Engineering', 'sanya.malhotra@example.com'),
(465, 'Devansh Bansal', 'Aeronautical and Automobile Engineering', 'devansh.bansal@example.com'),
(466, 'Trisha Gupta', 'Biotechnology', 'trisha.gupta@example.com'),
(467, 'Aarav Desai', 'Mechanical Engineering', 'aarav.desai@example.com'),
(468, 'Jatin Iyer', 'Computer Science', 'jatin.iyer@example.com'),
(469, 'Rishika Sinha', 'Mechatronics', 'rishika.sinha@example.com'),
(470, 'Ayaan Verma', 'Electronics and Communication Engineering', 'ayaan.verma@example.com');

-- INSERT INTO student_project
INSERT INTO student_project (studproj_name, dept_name, advisor) VALUES
('Formula Manipal', 'Mechanical Engineering', 101),
('Solar-Mobil', 'Mechatronics', 102),
('Project MANAS', 'Computer Science', 103),
('Mars Rover Manipal', 'Mechanical Engineering', 104),
('RoboManipal', 'Mechanical Engineering', 105),
('MotoManipal', 'Mechanical Engineering', 106),
('Team Manipal Racing', 'Mechanical Engineering', 107),
('Aero-MIT', 'Aeronautical and Automobile Engineering', 108),
('Parikshit', 'Electronics and Communication Engineering', 109),
('ThrustMIT', 'Aeronautical and Automobile Engineering', 110),
('Robotics and Circuits', 'Electronics and Communication Engineering', 111),
('R.U.G.V.E.D', 'Mechatronics', 112),
('Manipal BioMachines', 'Biotechnology', 113),
('loopMIT', 'Electronics and Instrumentation Engineering', 114),
('Project AUV Manipal', 'Aeronautical Engineering', 115),
('Team Combat Robotics', 'Mechanical Engineering', 116),
('Cryptonite', 'Computer Science', 117),
('Project Dronaid', 'Aeronautical Engineering', 118),
('Team Karting Manipal', 'Mechanical Engineering', 119),
('Project Kalpana', 'Electronics and Communication Engineering', 120);

-- INSERT INTO funded_by

INSERT INTO funded_by (studproj_name, dept_name) VALUES
('Formula Manipal', 'Mechanical Engineering'),
('Solar-Mobil', 'Mechatronics'),
('Project MANAS', 'Computer Science'),
('Mars Rover Manipal', 'Mechanical Engineering'),
('RoboManipal', 'Mechanical Engineering'),
('MotoManipal', 'Mechanical Engineering'),
('Team Manipal Racing', 'Mechanical Engineering'),
('Aero-MIT', 'Aeronautical and Automobile Engineering'),
('Parikshit', 'Electronics and Communication Engineering'),
('ThrustMIT', 'Aeronautical and Automobile Engineering'),
('Robotics and Circuits', 'Electronics and Communication Engineering'),
('R.U.G.V.E.D', 'Mechatronics'),
('Manipal BioMachines', 'Biotechnology'),
('loopMIT', 'Electronics and Instrumentation Engineering'),
('Project AUV Manipal', 'Aeronautical Engineering'),
('Team Combat Robotics', 'Mechanical Engineering'),
('Cryptonite', 'Computer Science'),
('Project Dronaid', 'Aeronautical Engineering'),
('Team Karting Manipal', 'Mechanical Engineering'),
('Project Kalpana', 'Electronics and Communication Engineering');

-- INSERT INTO works_on
-- Mars Rover Manipal
INSERT INTO works_on VALUES 
(462, 'Mars Rover Manipal'), (273, 'Mars Rover Manipal'), (467, 'Mars Rover Manipal'),
(201, 'Mars Rover Manipal'), (414, 'Mars Rover Manipal'), (441, 'Mars Rover Manipal'),
(423, 'Mars Rover Manipal'), (221, 'Mars Rover Manipal'), (210, 'Mars Rover Manipal'),
(463, 'Mars Rover Manipal');

-- RoboManipal
INSERT INTO works_on VALUES 
(426, 'RoboManipal'), (416, 'RoboManipal'), (282, 'RoboManipal'), (322, 'RoboManipal'),
(407, 'RoboManipal'), (228, 'RoboManipal'), (440, 'RoboManipal'), (214, 'RoboManipal'),
(421, 'RoboManipal'), (204, 'RoboManipal');

-- MotoManipal
INSERT INTO works_on VALUES 
(278, 'MotoManipal'), (453, 'MotoManipal'), (431, 'MotoManipal'), (446, 'MotoManipal'),
(420, 'MotoManipal'), (209, 'MotoManipal'), (470, 'MotoManipal'), (448, 'MotoManipal'),
(277, 'MotoManipal'), (413, 'MotoManipal');

-- Team Manipal Racing
INSERT INTO works_on VALUES 
(205, 'Team Manipal Racing'), (465, 'Team Manipal Racing'), (419, 'Team Manipal Racing'),
(276, 'Team Manipal Racing'), (435, 'Team Manipal Racing'), (458, 'Team Manipal Racing'),
(428, 'Team Manipal Racing'), (287, 'Team Manipal Racing'), (445, 'Team Manipal Racing'),
(230, 'Team Manipal Racing');

-- Aero-MIT
INSERT INTO works_on VALUES 
(451, 'Aero-MIT'), (405, 'Aero-MIT'), (280, 'Aero-MIT'), (449, 'Aero-MIT'),
(206, 'Aero-MIT'), (429, 'Aero-MIT'), (403, 'Aero-MIT'), (454, 'Aero-MIT'),
(468, 'Aero-MIT'), (327, 'Aero-MIT');

-- Parikshit
INSERT INTO works_on VALUES 
(434, 'Parikshit'), (203, 'Parikshit'), (455, 'Parikshit'), (321, 'Parikshit'),
(438, 'Parikshit'), (436, 'Parikshit'), (430, 'Parikshit'), (217, 'Parikshit'),
(283, 'Parikshit'), (223, 'Parikshit');

-- ThrustMIT
INSERT INTO works_on VALUES 
(410, 'ThrustMIT'), (225, 'ThrustMIT'), (444, 'ThrustMIT'), (279, 'ThrustMIT'),
(427, 'ThrustMIT'), (324, 'ThrustMIT'), (442, 'ThrustMIT'), (213, 'ThrustMIT'),
(286, 'ThrustMIT'), (219, 'ThrustMIT');

-- Robotics and Circuits
INSERT INTO works_on VALUES 
(330, 'Robotics and Circuits'), (433, 'Robotics and Circuits'), (284, 'Robotics and Circuits'),
(329, 'Robotics and Circuits'), (272, 'Robotics and Circuits'), (216, 'Robotics and Circuits'),
(439, 'Robotics and Circuits'), (417, 'Robotics and Circuits'), (460, 'Robotics and Circuits'),
(288, 'Robotics and Circuits');

-- R.U.G.V.E.D
INSERT INTO works_on VALUES 
(271, 'R.U.G.V.E.D'), (401, 'R.U.G.V.E.D'), (224, 'R.U.G.V.E.D'), (285, 'R.U.G.V.E.D'),
(415, 'R.U.G.V.E.D'), (275, 'R.U.G.V.E.D'), (229, 'R.U.G.V.E.D'), (218, 'R.U.G.V.E.D'),
(469, 'R.U.G.V.E.D'), (211, 'R.U.G.V.E.D');

-- Manipal BioMachines
INSERT INTO works_on VALUES 
(408, 'Manipal BioMachines'), (450, 'Manipal BioMachines'), (208, 'Manipal BioMachines'),
(328, 'Manipal BioMachines'), (457, 'Manipal BioMachines'), (207, 'Manipal BioMachines'),
(412, 'Manipal BioMachines'), (447, 'Manipal BioMachines'), (411, 'Manipal BioMachines'),
(281, 'Manipal BioMachines');

-- loopMIT
INSERT INTO works_on VALUES 
(464, 'loopMIT'), (409, 'loopMIT'), (425, 'loopMIT'), (437, 'loopMIT'),
(226, 'loopMIT'), (432, 'loopMIT'), (290, 'loopMIT'), (325, 'loopMIT'),
(215, 'loopMIT'), (212, 'loopMIT');

-- Project Kalpana
INSERT INTO works_on VALUES 
(456, 'Project Kalpana'), (323, 'Project Kalpana'), (402, 'Project Kalpana'),
(443, 'Project Kalpana'), (274, 'Project Kalpana'), (424, 'Project Kalpana'),
(326, 'Project Kalpana'), (452, 'Project Kalpana'), (466, 'Project Kalpana'),
(220, 'Project Kalpana');

-- Project AUV Manipal
INSERT INTO works_on VALUES 
(422, 'Project AUV Manipal'), (222, 'Project AUV Manipal'), (406, 'Project AUV Manipal'),
(459, 'Project AUV Manipal'), (461, 'Project AUV Manipal'), (202, 'Project AUV Manipal'),
(289, 'Project AUV Manipal'), (227, 'Project AUV Manipal'), (404, 'Project AUV Manipal'),
(418, 'Project AUV Manipal');


insert into subsystem values('Electrical', 'Mars Rover Manipal', '210');
insert into subsystem values('Management', 'Mars Rover Manipal', '221');
insert into subsystem values('Coding', 'Mars Rover Manipal', '273');
insert into subsystem values('Research', 'Mars Rover Manipal', '414');
insert into subsystem values('Mechanical', 'Aero-MIT', '206');
insert into subsystem values('Electrical', 'Aero-MIT', '280');
insert into subsystem values('Management', 'Aero-MIT', '327');
insert into subsystem values('Coding', 'Aero-MIT', '403');
insert into subsystem values('Research', 'Aero-MIT', '405');
insert into subsystem values('Research', 'loopMIT', '325');
insert into subsystem values('Coding', 'loopMIT', '290');
insert into subsystem values('Management', 'loopMIT', '226');
insert into subsystem values('Electrical', 'loopMIT', '215');
insert into subsystem values('Mechanical', 'loopMIT', '212');
insert into subsystem values('Mechanical', 'Manipal BioMachines', '207');
insert into subsystem values('Electrical', 'Manipal BioMachines', '208');
insert into subsystem values('Management', 'Manipal BioMachines', '281');
insert into subsystem values('Coding', 'Manipal BioMachines', '328');
insert into subsystem values('Research', 'Manipal BioMachines', '408');
insert into subsystem values('Mechanical', 'MotoManipal', '209');
insert into subsystem values('Electrical', 'MotoManipal', '277');
insert into subsystem values('Management', 'MotoManipal', '278');
insert into subsystem values('Coding', 'MotoManipal', '413');
insert into subsystem values('Research', 'MotoManipal', '420');
insert into subsystem values('Mechanical', 'Parikshit', '203');
insert into subsystem values('Electrical', 'Parikshit', '217');
insert into subsystem values('Management', 'Parikshit', '223');
insert into subsystem values('Coding', 'Parikshit', '283');
insert into subsystem values('Research', 'Parikshit', '321');
insert into subsystem values('Mechanical', 'Project AUV Manipal', '202');
insert into subsystem values('Electrical', 'Project AUV Manipal', '222');
insert into subsystem values('Management', 'Project AUV Manipal', '227');
insert into subsystem values('Research', 'Project AUV Manipal', '289');
insert into subsystem values('Coding', 'Project AUV Manipal', '404');
insert into subsystem values('Coding', 'Project Kalpana', '220');
insert into subsystem values('Research', 'Project Kalpana', '274');
insert into subsystem values('Management', 'Project Kalpana', '323');
insert into subsystem values('Electrical', 'Project Kalpana', '326');
insert into subsystem values('Mechanical', 'Project Kalpana', '402');
insert into subsystem values('Mechanical', 'R.U.G.V.E.D', '221');
insert into subsystem values('Electrical', 'R.U.G.V.E.D', '218');
insert into subsystem values('Management', 'R.U.G.V.E.D', '224');
insert into subsystem values('Research', 'R.U.G.V.E.D', '229');
insert into subsystem values('Coding', 'R.U.G.V.E.D', '271');
insert into subsystem values('Mechanical', 'RoboManipal', '204');
insert into subsystem values('Electrical', 'RoboManipal', '214');
insert into subsystem values('Research', 'RoboManipal', '228');
insert into subsystem values('Coding', 'RoboManipal', '282');
insert into subsystem values('Management', 'RoboManipal', '322');
insert into subsystem values('Mechanical', 'Team Manipal Racing', '205');
insert into subsystem values('Electrical', 'Team Manipal Racing', '230');
insert into subsystem values('Research', 'Team Manipal Racing', '276');
insert into subsystem values('Coding', 'Team Manipal Racing', '287');
insert into subsystem values('Management', 'Team Manipal Racing', '419');
insert into subsystem values('Management', 'ThrustMIT', '213');
insert into subsystem values('Coding', 'ThrustMIT', '219');
insert into subsystem values('Electrical', 'ThrustMIT', '225');
insert into subsystem values('Mechanical', 'ThrustMIT', '279');
insert into subsystem values('Research', 'ThrustMIT', '286');
insert into subsystem values('Research', 'Robotics and Circuits', '216');
insert into subsystem values('Management', 'Robotics and Circuits', '272');
insert into subsystem values('Electrical', 'Robotics and Circuits', '284');
insert into subsystem values('Mechanical', 'Robotics and Circuits', '288');
insert into subsystem values('Coding', 'Robotics and Circuits', '329');


--Trigger for automatically updating the department budget
DELIMITER $$

CREATE TRIGGER decrease_budget_after_approval
AFTER UPDATE ON fund_request
FOR EACH ROW
BEGIN
    DECLARE v_dept_name VARCHAR(100);

    -- Only proceed if the status is being changed to 'approved'
    IF NEW.status = 'approved' AND OLD.status != 'approved' THEN

        -- Get the department associated with the project
        SELECT dept_name INTO v_dept_name
        FROM student_project
        WHERE studproj_name = NEW.project_name
        LIMIT 1;

        -- Deduct the amount from the department budget
        UPDATE department
        SET budget = budget - NEW.amount
        WHERE dept_name = v_dept_name;
    END IF;
END$$

DELIMITER ;
