--Entity Creation
--Tables with PK first

CREATE TABLE IF NOT EXISTS Attendee(
    Attendee_id integer primary key AUTOINCREMENT,
    Email varchar(50) NOT NULL UNIQUE,
    First_name varchar(50) NOT NULL,
    Last_name varchar(50) NOT NULL,
    Created_date datetime DEFAULT CURRENT_TIMESTAMP );
    
CREATE TABLE IF NOT EXISTS Artist(
    Artist_id integer primary key AUTOINCREMENT,
    Name varchar(50) NOT NULL,
    Description text NOT NULL,
    Is_band boolean NOT NULL,
    Genre varchar(50) NOT NULL);
    
CREATE TABLE IF NOT EXISTS Stage(
    Stage_id integer primary key AUTOINCREMENT,
    Name varchar(50) NOT NULL UNIQUE,
    Location_description text);

CREATE TABLE IF NOT EXISTS Ticket_Type(
    Ticket_type_id integer primary key AUTOINCREMENT,
    Type_name varchar(50) NOT NULL,
    Pass_type varchar(50) NOT NULL CHECK (Pass_type IN (
        'Festival_Day',
        'Festival_Multi',
        'VIP_Day',
        'VIP_Multi',
        'Camping')), --Ensures only 'Festival_Day', 'Festival_Multi','VIP_Day', and 'VIP_Multi' are entered for Pass_type.
    Price decimal(6,2),
    Description text,
    Valid_date datetime);

    
CREATE TABLE IF NOT EXISTS Entertainment_venue(
    Venue_id integer primary key AUTOINCREMENT,
    Venue_name varchar(50) NOT NULL,
    Venue_type varchar(50) NOT NULL,
    Description text,
    Operating_hours text);
    
--Tables with FK
PRAGMA foreign_keys = ON; --Enforces FK realtionships, Off by default. 

CREATE TABLE IF NOT EXISTS Performance(
    Performance_id integer primary key AUTOINCREMENT,
    Artist_id integer NOT NULL,
    Stage_id integer NOT NULL,
    Performance_date date NOT NULL,
    Start_time time NOT NULL,
    End_time time NOT NULL,
    Foreign key (Artist_id) references Artist (Artist_id),
    Foreign key (Stage_id) references Stage (Stage_id)
);

CREATE TABLE IF NOT EXISTS Booking(
    Booking_id integer primary key AUTOINCREMENT,
    Attendee_id integer NOT NULL,
    Booking_date datetime NOT NULL,
    Total_amount decimal(10,2),
    Foreign key (Attendee_id) references Attendee (Attendee_id)
);

CREATE TABLE IF NOT EXISTS Booking_Line_Item(
    Line_item_id integer primary key AUTOINCREMENT,
    Booking_id integer NOT NULL,
    Ticket_type_id integer NOT NULL,
    Quantity integer NOT NULL DEFAULT 1, --In the event that no value is entered, 1 is automatically added as default. 
    Foreign key (Booking_id) references Booking (Booking_id),
    Foreign key (Ticket_type_id) references Ticket_Type (Ticket_type_id)
);

CREATE TABLE IF NOT EXISTS Personal_Schedule(
    Schedule_id integer primary key AUTOINCREMENT,
    Attendee_id integer NOT NULL,
    Performance_id integer NOT NULL,
    Foreign key (Attendee_id) references Attendee (Attendee_id),
    Foreign key (Performance_id) references Performance (Performance_id)
);

CREATE TABLE IF NOT EXISTS Camping_Reservation(
    Reservation_id integer primary key AUTOINCREMENT,
    Attendee_id integer NOT NULL,
    Camping_type varchar(20) NOT NULL CHECK (Camping_type IN ('Basic', 'Premium')), --Esures that only Camping_types 'Basic' and 'Premium' are entered
    Start_date date NOT NULL,
    End_date date NOT NULL,
    Price decimal(6,2),
    Foreign key (Attendee_id) references Attendee(Attendee_id)
);

CREATE UNIQUE INDEX stage_time
ON Performance(Stage_id, Performance_date, Start_time); --Prevent same time booking of a stage

CREATE UNIQUE INDEX attendee_performance
ON Personal_Schedule(Attendee_id, Performance_id); --Prevents attendee from entring the same schedule multiple times 

-- Essential starter set for festival:
/*CREATE INDEX idx_performance_artist_id ON Performance(Artist_id);
CREATE INDEX idx_performance_stage_id ON Performance(Stage_id);
CREATE INDEX idx_booking_attendee_id ON Booking(Attendee_id);
CREATE INDEX idx_line_item_booking_id ON Booking_Line_Item(Booking_id);
CREATE INDEX idx_line_item_ticket_type_id ON Booking_Line_Item(Ticket_type_id);
CREATE INDEX idx_schedule_attendee_id ON Personal_Schedule(Attendee_id);
CREATE INDEX idx_schedule_performance_id ON Personal_Schedule(Performance_id);
CREATE INDEX idx_performance_date ON Performance(Performance_date);*/

DROP INDEX idx_performance_artist_id;
DROP INDEX idx_performance_stage_id;
DROP INDEX idx_performance_date;

CREATE INDEX idx_performance_optimised ON Performance(Artist_id, Stage_id, Performance_date, Start_time);

DROP INDEX idx_schedule_attendee_id;
DROP INDEX idx_schedule_performance_id;
DROP INDEX idx_booking_attendee_id;

CREATE INDEX idx_booking_date_attendee ON Booking(Booking_date, Attendee_id);

--Data Population
--Independent tabels first i.e tables without FK

Pragma foreign_keys = ON;

INSERT INTO Artist 
VALUES (101, 'The Rolling Scones', 'A classic rock band known for their energetic performances.', True, 'Rock');
INSERT INTO Artist
VALUES (102, 'Arctic Marmosets', 'Indie rock band famous for their cryptic lyrics.', True, 'Indie rock'),
(103, 'Flue Fighters', 'A rock group known for their powerful guitar riffs and dynamic stage presence.', True, 'Rock'),
(104, 'Lady Baba', 'Pop icon with a powerful voice and dramatic stage costumes.', False, 'Pop'),
(105, 'Red Hot Chili Poppers', 'Funk rock band that combines funky grooves with an energetic performance.', True, 'Rock'),
(106, 'Image Drag-ons', 'A fantasy-themed band that dresses as dragons and other mythical creatures.', True, 'Fantacy Rock'),
(107, 'Bleetwood Mac', 'A synth-pop band with an affinity for electronic remixes of classic songs.', True, 'Pop'),
(108, 'Metallicalica', 'A heavy metal band known for their thunderous sound and complex compositions.', True, 'Heavy metal'),
(109, 'Adele-driod', 'A futuristic pop singer with digital and holographic stage elements.', False, 'Pop'),
(110, 'Snoop Corgi', 'A rapper famous for his laid-back style and animal-themed lyrics.', False, 'Hiphop Rap'),
(111, 'Muse-ical', 'Known for their dramatic orchestral rock performances that tell a story.', False, 'Orchestral Rock'),
(112, 'Nine Inch Snails', 'A band that combines industrial rock with environmental messages.', True, 'Industrial Rock'),
(113, 'Queen Elizabeth', 'A cover band that exclusively plays hits from Queen with a regal flair.', True, 'Classic Rock'),
(114, 'Gorill-az', 'An animated band with characters performing via augmented reality.', True, 'Alternative'),
(115, 'The Beetles', 'A group known for their eco-friendly songs and activism.', True, 'Rock'),
(116, 'Katy Ferry', 'A pop artist famous for her nautical-themed performances.', False, 'Pop'),
(117, 'J-Zeebra', 'A hip-hop artist known for his sharp lyrics and striped stage costumes.', False, 'Hip-Hop'),
(118, 'Post Malogne', 'A post-genre artist blending elements from folk, rap, and electronic music.', False, 'Experimental'),
(119, 'The Weekend Update', 'A band that incorporates news and current events into their lyrics.', True, 'Alternative Rock'),
(120, 'Rage Against the Espresso Machine', 'Known for their energetic performances and coffee-themed merchandise.', True, 'Punk Rock'),
(121, 'Marshmell-oh', 'An electronic dance music artist who performs wearing a giant marshmallow head.', False, 'EDM'),
(122, 'The Stalking Heads', 'A band that combines punk rock with spoken word poetry.', True, 'Punk'),
(123, 'Pink-Flyod', 'A tribute band that uses experimental sound techniques.',True, 'Progressive Rock'),
(124, 'Kings of Lion''s Den', 'Rock music with a biblical twist.', True, 'Rock'),
(125, 'The Kill-Joy Division', 'A post-punk band with a penchant for upbeat, danceable tracks.', True, 'Post-Punk'),
(126, 'Chain Smokers Anonymous', 'A duo that combines electronic music with a focus on health and wellness.', True, 'Electronic'),
(127, 'Echoes of Nowhere', 'A dream pop band known for ethereal soundscapes.', True, 'Dream Pop'),
(128, 'Silver Strings', 'A modern bluegrass band with a vibrant stage presence.', True, 'Bluegrass'),
(129, 'Night Howls', 'A garage rock band with gritty vocals and sharp guitar riffs.', True, 'Garage Rock'),
(130, 'Oceanic Drift', 'An ambient music group focusing on ocean-themed soundtracks.', True, 'Ambient'),
(131, 'Skylight Serenade', 'A classical crossover group blending symphonic elements with electronic beats.', True, 'Classical Crossover'),
(132, 'Polar Groove', 'An ice-themed performance group combining visual arts and chillstep music.', True, 'Chillstep'),
(133, 'Velvet Vortex', 'An alternative soul band known for its smooth rhythms and heartfelt lyrics.', True, 'Soul'),
(134, 'Cyber Symphony', 'A techno-classical fusion ensemble that combines orchestral sounds with electronic beats.', True, 'Techno-Classical'),
(135, 'Lunar Tides', 'An indie pop group with catchy tunes inspired by celestial themes.', True, 'Indie Pop'),
(136, 'Desert Winds', 'A world music band that blends traditional Middle Eastern instruments with modern jazz influences.', True, 'World Jazz'),
(137, 'Thunder Echoes', 'A hard rock band with a penchant for loud, anthemic tracks.', True, 'Hard Rock'),
(138, 'Neon Grooves', 'A disco revival band bringing the sparkle and dance beats of the 70s back to life.', True, 'Disco'),
(139, 'Twilight Serenaders', 'A folk duo known for their harmonious vocals and acoustic guitar.', True, 'Folk'),
(140, 'Digital Dreams', 'An EDM artist with a visual show that complements high-energy dance music with futuristic imagery.', False, 'EDM'),
(141, 'Harmonic Dusk', 'A smooth jazz ensemble perfect for unwinding and relaxing.', False, 'Smooth Jazz'),
(142, 'Retro Spectrum', 'A band that revisits 80s pop rock with a modern twist.', False, 'Pop Rock');

SELECT * FROM Artist; 
 

INSERT INTO Stage (Stage_id, Name, Location_description) VALUES
(1, 'Main Stage', 'The festival''s largest stage, hosting headline performances.'),
(2, 'Groove Grounds', 'Focused on electronic and dance music.'),
(3, 'Acoustic Corner', 'Intimate sets for folk and acoustic genres.'),
(4, 'Rock Riff Ridge', 'Dedicated to rock and heavy metal bands.'),
(5, 'Chillout Lounge', 'A smaller venue for ambient and relaxing music sets.');

SELECT * FROM Stage;


INSERT INTO Ticket_Type (Ticket_type_id, Type_name, Pass_type, Price, Description, Valid_date) VALUES
-- Festival Day Passes(3)
(1, 'Friday Day Pass', 'Festival_Day', 89.99, 'General admission for Friday only', '2025-07-26'),
(2, 'Saturday Day Pass', 'Festival_Day', 99.99, 'General admission for Saturday only', '2025-07-27'),
(3, 'Sunday Day Pass', 'Festival_Day', 89.99, 'General admission for Sunday only', '2025-07-28'),
-- Festival Multi-Day Passes(3)
(4, 'Weekend Pass', 'Festival_Multi', 229.99, 'General admission for all three days (Friday-Sunday)', NULL),
(5, 'Friday-Saturday Pass', 'Festival_Multi', 169.99, 'General admission for Friday and Saturday', NULL),
(6, 'Saturday-Sunday Pass', 'Festival_Multi', 169.99, 'General admission for Saturday and Sunday', NULL),
-- VIP Day Passes(3)
(7, 'VIP Friday Pass', 'VIP_Day', 149.99, 'VIP access with backstage and premium viewing for Friday', '2025-07-26'),
(8, 'VIP Saturday Pass', 'VIP_Day', 159.99, 'VIP access with backstage and premium viewing for Saturday', '2025-07-27'),
(9, 'VIP Sunday Pass', 'VIP_Day', 149.99, 'VIP access with backstage and premium viewing for Sunday', '2025-07-28'),
-- VIP Multi-Day Passes(1)
(10, 'VIP Weekend Pass', 'VIP_Multi', 399.99, 'Full VIP access with all benefits for all three days', NULL),
-- Camping Options
(11, 'Basic Camping', 'Camping', 49.99, 'Tent spot in general camping area', NULL),
(12, 'Premium Camping', 'Camping', 99.99, 'Pre-setup tent with power and closer location', NULL);

SELECT * FROM Ticket_Type;


INSERT INTO Entertainment_venue (Venue_id, Venue_name, Venue_type, Description, Operating_hours) VALUES
(1, 'Comedy Tent', 'Comedy', 'Stand-up comedy acts featuring various comedians throughout the festival', '12:00-23:00 Daily'),
(2, 'Cinema Dome', 'Cinema', 'Outdoor film screenings including indie films and festival-themed movies', '14:00-02:00 Daily'),
(3, 'Art Gallery', 'Art', 'Modern art installations and exhibitions from contemporary artists', '11:00-20:00 Daily'),
(4, 'Craft Market', 'Shopping', 'Handmade goods, crafts, and unique festival merchandise from local artisans', '10:00-22:00 Daily'),
(5, 'Food and Brew Street', 'Food & Drink', 'International cuisines, food trucks, and craft beer from around the world', '11:00-24:00 Daily'),
(6, 'Wellness Pavilion', 'Wellness', 'Health and relaxation activities including yoga, meditation, and massage', '08:00-20:00 Daily'),
(7, 'Gaming Arcade', 'Gaming', 'Classic and modern arcade games, VR experiences, and gaming tournaments', '12:00-24:00 Daily');

SELECT * FROM Entertainment_venue;


INSERT INTO Attendee (Email, First_name, Last_name, Created_date) VALUES
-- Early Birds (May 20-31) - 10 attendees
('sarah.johnson@email.com', 'Sarah', 'Johnson', '2025-05-20 08:15:00'),
('mike.chen@email.com', 'Mike', 'Chen', '2025-05-22 14:30:00'),
('emma.rodriguez@email.com', 'Emma', 'Rodriguez', '2025-05-24 11:20:00'),
('james.wilson@email.com', 'James', 'Wilson', '2025-05-25 16:45:00'),
('lisa.garcia@email.com', 'Lisa', 'Garcia', '2025-05-26 09:30:00'),
('david.kim@email.com', 'David', 'Kim', '2025-05-27 13:15:00'),
('amanda.brown@email.com', 'Amanda', 'Brown', '2025-05-28 19:20:00'),
('chris.miller@email.com', 'Chris', 'Miller', '2025-05-29 10:45:00'),
('jessica.taylor@email.com', 'Jessica', 'Taylor', '2025-05-30 15:10:00'),
('alex.martinez@email.com', 'Alex', 'Martinez', '2025-05-31 12:25:00'),
-- Main Wave (June 1-15) - 15 attendees
('rachel.lee@email.com', 'Rachel', 'Lee', '2025-06-01 14:00:00'),
('kevin.davis@email.com', 'Kevin', 'Davis', '2025-06-02 16:30:00'),
('megan.white@email.com', 'Megan', 'White', '2025-06-03 10:15:00'),
('ryan.thomas@email.com', 'Ryan', 'Thomas', '2025-06-04 18:45:00'),
('lauren.moore@email.com', 'Lauren', 'Moore', '2025-06-05 11:20:00'),
('jordan.clark@email.com', 'Jordan', 'Clark', '2025-06-06 13:40:00'),
('olivia.anderson@email.com', 'Olivia', 'Anderson', '2025-06-07 15:55:00'),
('tyler.harris@email.com', 'Tyler', 'Harris', '2025-06-08 09:10:00'),
('sophia.lewis@email.com', 'Sophia', 'Lewis', '2025-06-09 17:25:00'),
('brandon.walker@email.com', 'Brandon', 'Walker', '2025-06-10 12:50:00'),
('ashley.young@email.com', 'Ashley', 'Young', '2025-06-11 14:15:00'),
('matthew.king@email.com', 'Matthew', 'King', '2025-06-12 16:40:00'),
('emily.scott@email.com', 'Emily', 'Scott', '2025-06-13 10:05:00'),
('joshua.green@email.com', 'Joshua', 'Green', '2025-06-14 19:30:00'),
('victoria.adams@email.com', 'Victoria', 'Adams', '2025-06-15 11:45:00'),
-- Late Bookings (June 16-30) - 15 attendees
('andrew.nelson@email.com', 'Andrew', 'Nelson', '2025-06-16 13:20:00'),
('hannah.baker@email.com', 'Hannah', 'Baker', '2025-06-17 15:35:00'),
('daniel.carter@email.com', 'Daniel', 'Carter', '2025-06-18 08:50:00'),
('isabella.mitchell@email.com', 'Isabella', 'Mitchell', '2025-06-19 17:05:00'),
('nicholas.perez@email.com', 'Nicholas', 'Perez', '2025-06-20 12:30:00'),
('grace.roberts@email.com', 'Grace', 'Roberts', '2025-06-21 14:55:00'),
('justin.turner@email.com', 'Justin', 'Turner', '2025-06-22 09:10:00'),
('natalie.phillips@email.com', 'Natalie', 'Phillips', '2025-06-23 18:25:00'),
('aaron.campbell@email.com', 'Aaron', 'Campbell', '2025-06-24 11:40:00'),
('chloe.parker@email.com', 'Chloe', 'Parker', '2025-06-25 16:05:00'),
('patrick.evans@email.com', 'Patrick', 'Evans', '2025-06-26 10:20:00'),
('zoe.edwards@email.com', 'Zoe', 'Edwards', '2025-06-27 19:35:00'),
('adam.collins@email.com', 'Adam', 'Collins', '2025-06-28 12:50:00'),
('lily.stewart@email.com', 'Lily', 'Stewart', '2025-06-29 15:15:00'),
('nathan.sanchez@email.com', 'Nathan', 'Sanchez', '2025-06-30 08:30:00'),
-- Last Minute Rush (July 1-25) - 10 attendees
('madison.morris@email.com', 'Madison', 'Morris', '2025-07-01 17:45:00'),
('carlos.rogers@email.com', 'Carlos', 'Rogers', '2025-07-05 11:00:00'),
('avery.reed@email.com', 'Avery', 'Reed', '2025-07-10 14:25:00'),
('kyle.cook@email.com', 'Kyle', 'Cook', '2025-07-15 09:40:00'),
('aria.morgan@email.com', 'Aria', 'Morgan', '2025-07-18 18:55:00'),
('peter.bell@email.com', 'Peter', 'Bell', '2025-07-20 13:10:00'),
('hailey.murphy@email.com', 'Hailey', 'Murphy', '2025-07-22 16:35:00'),
('sean.cooper@email.com', 'Sean', 'Cooper', '2025-07-23 10:50:00'),
('eleanor.richardson@email.com', 'Eleanor', 'Richardson', '2025-07-24 19:05:00'),
('logan.cox@email.com', 'Logan', 'Cox', '2025-07-25 12:20:00');

SELECT * FROM Attendee;

--Dependant tables i.e tables with FK

Pragma foreign_keys = ON;

INSERT INTO Performance (Artist_id, Stage_id, Performance_date, Start_time, End_time) VALUES
-- ===== FRIDAY, JULY 25, 2025 =====

-- Main Stage (Headliners)
(101, 1, '2025-07-25', '20:00', '21:30'),  -- The Rolling Scones (Fri Headliner)
(112, 1, '2025-07-25', '17:00', '18:00'),  -- Nine Inch Snails (Early Evening)
(124, 1, '2025-07-25', '22:00', '23:30'),  -- Kings of Lion's Den (Late Night)

-- Groove Grounds (Electronic/Dance)
(121, 2, '2025-07-25', '18:00', '19:30'),  -- Marshmell-oh
(140, 2, '2025-07-25', '20:00', '21:30'),  -- Digital Dreams
(126, 2, '2025-07-25', '22:00', '23:30'),  -- Chain Smokers Anonymous (Late Set)

-- Acoustic Corner
(116, 3, '2025-07-25', '16:00', '17:00'),  -- Katy Ferry (Acoustic Set)
(139, 3, '2025-07-25', '17:30', '18:30'),  -- Twilight Serenaders
(128, 3, '2025-07-25', '19:00', '20:00'),  -- Silver Strings

-- Rock Riff Ridge
(120, 4, '2025-07-25', '17:00', '18:00'),  -- Rage Against the Espresso Machine
(137, 4, '2025-07-25', '18:30', '19:30'),  -- Thunder Echoes
(108, 4, '2025-07-25', '20:00', '21:30'),  -- Metallicalica

-- Chillout Lounge
(130, 5, '2025-07-25', '16:00', '17:00'),  -- Oceanic Drift
(141, 5, '2025-07-25', '17:30', '18:30'),  -- Harmonic Dusk
(132, 5, '2025-07-25', '19:00', '20:00'),  -- Polar Groove

-- ===== SATURDAY, JULY 26, 2025 =====

-- Main Stage (Headliners)
(113, 1, '2025-07-26', '20:00', '21:30'),  -- Queen Elizabeth (Sat Headliner)
(118, 1, '2025-07-26', '17:00', '18:00'),  -- Post Malogne (Early Set)
(111, 1, '2025-07-26', '22:00', '23:30'),  -- Muse-ical (Late Night)

-- Groove Grounds
(114, 2, '2025-07-26', '18:00', '19:30'),  -- Gorill-az
(138, 2, '2025-07-26', '20:00', '21:30'),  -- Neon Grooves
(107, 2, '2025-07-26', '22:00', '23:30'),  -- Bleetwood Mac (Late Set)

-- Acoustic Corner
(102, 3, '2025-07-26', '14:00', '15:00'),  -- Arctic Marmosets (Acoustic)
(139, 3, '2025-07-26', '15:30', '16:30'),  -- Twilight Serenaders (2nd Day)
(128, 3, '2025-07-26', '17:00', '18:00'),  -- Silver Strings (2nd Day)

-- Rock Riff Ridge
(103, 4, '2025-07-26', '15:00', '16:00'),  -- Flue Fighters
(120, 4, '2025-07-26', '16:30', '17:30'),  -- Rage Against the Espresso Machine (2nd Day)
(125, 4, '2025-07-26', '18:00', '19:00'),  -- The Kill-Joy Division

-- Chillout Lounge
(131, 5, '2025-07-26', '14:00', '15:00'),  -- Skylight Serenade
(141, 5, '2025-07-26', '15:30', '16:30'),  -- Harmonic Dusk (2nd Day)
(130, 5, '2025-07-26', '17:00', '18:00'),  -- Oceanic Drift (2nd Day)

-- ===== SUNDAY, JULY 27, 2025 =====

-- Main Stage (Headliners)
(115, 1, '2025-07-27', '19:00', '20:30'),  -- The Beetles (Sun Headliner)
(118, 1, '2025-07-27', '16:00', '17:00'),  -- Post Malogne (Afternoon Set)
(142, 1, '2025-07-27', '21:00', '22:30'),  -- Retro Spectrum (Closing Act)

-- Groove Grounds
(109, 2, '2025-07-27', '15:00', '16:00'),  -- Adele-driod
(140, 2, '2025-07-27', '17:00', '18:00'),  -- Digital Dreams (2nd Day)
(126, 2, '2025-07-27', '19:00', '20:00'),  -- Chain Smokers Anonymous (2nd Day)

-- Acoustic Corner
(135, 3, '2025-07-27', '14:00', '15:00'),  -- Lunar Tides
(139, 3, '2025-07-27', '15:30', '16:30'),  -- Twilight Serenaders (3rd Day!)
(116, 3, '2025-07-27', '17:00', '18:00'),  -- Katy Ferry (2nd Acoustic Set)

-- Rock Riff Ridge
(129, 4, '2025-07-27', '14:00', '15:00'),  -- Night Howls
(137, 4, '2025-07-27', '15:30', '16:30'),  -- Thunder Echoes (2nd Day)
(105, 4, '2025-07-27', '17:00', '18:00'),  -- Red Hot Chili Poppers

-- Chillout Lounge
(136, 5, '2025-07-27', '14:00', '15:00'),  -- Desert Winds
(132, 5, '2025-07-27', '15:30', '16:30'),  -- Polar Groove (2nd Day)
(133, 5, '2025-07-27', '17:00', '18:00'),  -- Velvet Vortex

-- ===== ADDITIONAL ARTISTS TO COVER ALL 42 =====

-- Lady Baba (Pop - Missing Artist 104)
(104, 1, '2025-07-26', '15:00', '16:00'),  -- Saturday Main Stage

-- Image Drag-ons (Fantasy Rock - Missing Artist 106)  
(106, 4, '2025-07-27', '13:00', '14:00'),  -- Sunday Rock Riff Ridge (Early)

-- Snoop Corgi (Hip-Hop - Missing Artist 110)
(110, 2, '2025-07-25', '16:00', '17:00'),  -- Friday Groove Grounds

-- ===== POPULAR ARTISTS MULTIPLE DAYS =====

-- J-Zeebra (Hip-Hop - Multiple Days)
(117, 2, '2025-07-25', '15:00', '16:00'),  -- Friday
(117, 2, '2025-07-26', '16:00', '17:00'),  -- Saturday
(117, 2, '2025-07-27', '18:00', '19:00'),  -- Sunday

-- The Weekend Update (Alternative - Multiple Days)
(119, 3, '2025-07-25', '14:00', '15:00'),  -- Friday
(119, 4, '2025-07-26', '19:30', '20:30'),  -- Saturday (Different Stage)
(119, 3, '2025-07-27', '16:30', '17:30'),  -- Sunday

-- Pink-Flyod (Progressive Rock - Multiple Days)
(123, 4, '2025-07-25', '15:00', '16:00'),  -- Friday
(123, 5, '2025-07-26', '19:00', '20:00'),  -- Saturday (Different Stage)
(123, 4, '2025-07-27', '20:00', '21:00'),  -- Sunday

-- Echoes of Nowhere (Dream Pop - Multiple Days)
(127, 5, '2025-07-25', '14:00', '15:00'),  -- Friday
(127, 1, '2025-07-26', '18:00', '19:00'),  -- Saturday (Main Stage!)
(127, 3, '2025-07-27', '18:30', '19:30'),  -- Sunday

-- Cyber Symphony (Techno-Classical)
(134, 2, '2025-07-25', '14:00', '15:00'); -- Friday

SELECT * FROM Performance;

-- Check that all 42 artists have performances
SELECT 
    COUNT(DISTINCT Artist_id) as artists_with_performances,
    (SELECT COUNT(*) FROM Artist) as total_artists
FROM Performance;

-- Find which artists don't have performances
SELECT a.Artist_id, a.Name
FROM Artist a
LEFT JOIN Performance p ON a.Artist_id = p.Artist_id
WHERE p.Performance_id IS NULL
ORDER BY a.Artist_id;

DELETE FROM Performance;
DELETE FROM sqlite_sequence WHERE name = 'Performance';


INSERT INTO Booking (Attendee_id, Booking_date, Total_amount) VALUES
-- Early Bird Bookings (May) - 10 attendees
(1, '2025-05-20 08:15:00', 279.98),   -- Sarah Johnson: Weekend Pass + Basic Camping
(2, '2025-05-22 14:30:00', 499.98),   -- Mike Chen: VIP Weekend + Premium Camping
(3, '2025-05-24 11:20:00', 169.99),   -- Emma Rodriguez: Friday-Saturday Pass
(4, '2025-05-25 16:45:00', 229.99),   -- James Wilson: Weekend Pass
(5, '2025-05-26 09:30:00', 89.99),    -- Lisa Garcia: Friday Pass
(6, '2025-05-27 13:15:00', 99.99),    -- David Kim: Saturday Pass
(7, '2025-05-28 19:20:00', 399.99),   -- Amanda Brown: VIP Weekend Pass
(8, '2025-05-29 10:45:00', 149.99),   -- Chris Miller: VIP Friday Pass
(9, '2025-05-30 15:10:00', 169.99),   -- Jessica Taylor: Saturday-Sunday Pass
(10, '2025-05-31 12:25:00', 89.99),   -- Alex Martinez: Sunday Pass

-- Main Wave Bookings (June 1-15) - 15 attendees
(11, '2025-06-01 14:00:00', 269.97),  -- Rachel Lee: 3x Friday Passes
(12, '2025-06-02 16:30:00', 199.98),  -- Kevin Davis: 2x Saturday Passes
(13, '2025-06-03 10:15:00', 229.99),  -- Megan White: Weekend Pass
(14, '2025-06-04 18:45:00', 399.99),  -- Ryan Thomas: VIP Weekend Pass
(15, '2025-06-05 11:20:00', 149.99),  -- Lauren Moore: VIP Friday Pass
(16, '2025-06-06 13:40:00', 169.99),  -- Jordan Clark: Saturday-Sunday Pass
(17, '2025-06-07 15:55:00', 89.99),   -- Olivia Anderson: Sunday Pass
(18, '2025-06-08 09:10:00', 279.98),  -- Tyler Harris: Weekend Pass + Basic Camping
(19, '2025-06-09 17:25:00', 99.99),   -- Sophia Lewis: Saturday Pass
(20, '2025-06-10 12:50:00', 89.99),   -- Brandon Walker: Friday Pass
(21, '2025-06-11 14:15:00', 229.99),  -- Ashley Young: Weekend Pass
(22, '2025-06-12 16:40:00', 159.99),  -- Matthew King: VIP Saturday Pass
(23, '2025-06-13 10:05:00', 169.99),  -- Emily Scott: Saturday-Sunday Pass
(24, '2025-06-14 19:30:00', 89.99),   -- Joshua Green: Sunday Pass
(25, '2025-06-15 11:45:00', 499.98),  -- Victoria Adams: VIP Weekend + Premium Camping

-- Late Bookings (June 16-30) - 15 attendees
(26, '2025-06-16 13:20:00', 229.99),  -- Andrew Nelson: Weekend Pass
(27, '2025-06-17 15:35:00', 99.99),   -- Hannah Baker: Saturday Pass
(28, '2025-06-18 08:50:00', 149.99),  -- Daniel Carter: VIP Friday Pass
(29, '2025-06-19 17:05:00', 89.99),   -- Isabella Mitchell: Friday Pass
(30, '2025-06-20 12:30:00', 169.99),  -- Nicholas Perez: Saturday-Sunday Pass
(31, '2025-06-21 14:55:00', 399.99),  -- Grace Roberts: VIP Weekend Pass
(32, '2025-06-22 09:10:00', 279.98),  -- Justin Turner: Weekend Pass + Basic Camping
(33, '2025-06-23 18:25:00', 99.99),   -- Natalie Phillips: Saturday Pass
(34, '2025-06-24 11:40:00', 89.99),   -- Aaron Campbell: Sunday Pass
(35, '2025-06-25 16:05:00', 149.99),  -- Chloe Parker: VIP Sunday Pass
(36, '2025-06-26 10:20:00', 229.99),  -- Patrick Evans: Weekend Pass
(37, '2025-06-27 19:35:00', 199.98),  -- Zoe Edwards: 2x Friday Passes
(38, '2025-06-28 12:50:00', 169.99),  -- Adam Collins: Saturday-Sunday Pass
(39, '2025-06-29 15:15:00', 89.99),   -- Lily Stewart: Friday Pass
(40, '2025-06-30 08:30:00', 499.98),  -- Nathan Sanchez: VIP Weekend + Premium Camping

-- Last Minute Rush (July 1-25) - 10 attendees
(41, '2025-07-01 17:45:00', 99.99),   -- Madison Morris: Saturday Pass
(42, '2025-07-05 11:00:00', 149.99),  -- Carlos Rogers: VIP Friday Pass
(43, '2025-07-10 14:25:00', 89.99),   -- Avery Reed: Sunday Pass
(44, '2025-07-15 09:40:00', 229.99),  -- Kyle Cook: Weekend Pass
(45, '2025-07-18 18:55:00', 169.99),  -- Aria Morgan: Saturday-Sunday Pass
(46, '2025-07-20 13:10:00', 399.99),  -- Peter Bell: VIP Weekend Pass
(47, '2025-07-22 16:35:00', 279.98),  -- Hailey Murphy: Weekend Pass + Basic Camping
(48, '2025-07-23 10:50:00', 99.99),   -- Sean Cooper: Saturday Pass
(49, '2025-07-24 19:05:00', 89.99),   -- Eleanor Richardson: Friday Pass
(50, '2025-07-25 12:20:00', 149.99);  -- Logan Cox: VIP Sunday Pass (Last Minute!)

SELECT * FROM Booking;

INSERT INTO Booking_Line_Item (Booking_id, Ticket_type_id, Quantity) VALUES
-- Bookings 1-10 (May)
(1, 4, 1), (1, 11, 1),   -- Weekend + Basic Camping
(2, 10, 1), (2, 12, 1),  -- VIP Weekend + Premium Camping
(3, 5, 1),               -- Friday-Saturday
(4, 4, 1),               -- Weekend
(5, 1, 1),               -- Friday
(6, 2, 1),               -- Saturday
(7, 10, 1),              -- VIP Weekend
(8, 7, 1),               -- VIP Friday
(9, 6, 1),               -- Saturday-Sunday
(10, 3, 1),              -- Sunday

-- Bookings 11-25 (June 1-15)
(11, 1, 3),              -- 3x Friday
(12, 2, 2),              -- 2x Saturday
(13, 4, 1),              -- Weekend
(14, 10, 1),             -- VIP Weekend
(15, 7, 1),              -- VIP Friday
(16, 6, 1),              -- Saturday-Sunday
(17, 3, 1),              -- Sunday
(18, 4, 1), (18, 11, 1), -- Weekend + Basic Camping
(19, 2, 1),              -- Saturday
(20, 1, 1),              -- Friday
(21, 4, 1),              -- Weekend
(22, 8, 1),              -- VIP Saturday
(23, 6, 1),              -- Saturday-Sunday
(24, 3, 1),              -- Sunday
(25, 10, 1), (25, 12, 1), -- VIP Weekend + Premium Camping

-- Bookings 26-40 (June 16-30)
(26, 4, 1),              -- Weekend
(27, 2, 1),              -- Saturday
(28, 7, 1),              -- VIP Friday
(29, 1, 1),              -- Friday
(30, 6, 1),              -- Saturday-Sunday
(31, 10, 1),             -- VIP Weekend
(32, 4, 1), (32, 11, 1), -- Weekend + Basic Camping
(33, 2, 1),              -- Saturday
(34, 3, 1),              -- Sunday
(35, 9, 1),              -- VIP Sunday
(36, 4, 1),              -- Weekend
(37, 1, 2),              -- 2x Friday
(38, 6, 1),              -- Saturday-Sunday
(39, 1, 1),              -- Friday
(40, 10, 1), (40, 12, 1), -- VIP Weekend + Premium Camping

-- Bookings 41-50 (July)
(41, 2, 1),              -- Saturday
(42, 7, 1),              -- VIP Friday
(43, 3, 1),              -- Sunday
(44, 4, 1),              -- Weekend
(45, 6, 1),              -- Saturday-Sunday
(46, 10, 1),             -- VIP Weekend
(47, 4, 1), (47, 11, 1), -- Weekend + Basic Camping
(48, 2, 1),              -- Saturday
(49, 1, 1),              -- Friday
(50, 9, 1);              -- VIP Sunday

-- Check that all 50 attendees have bookings
SELECT COUNT(DISTINCT Attendee_id) as attendees_with_bookings,
       (SELECT COUNT(*) FROM Attendee) as total_attendees
FROM Booking;

INSERT INTO Camping_Reservation (Attendee_id, Camping_type, Start_date, End_date, Price) VALUES
-- Early Birds (May) - 8 attendees camping
(1, 'Basic', '2025-07-25', '2025-07-27', 49.99),    -- Sarah Johnson - Full weekend
(2, 'Premium', '2025-07-25', '2025-07-27', 99.99),  -- Mike Chen - Premium full weekend
(3, 'Basic', '2025-07-25', '2025-07-26', 49.99),    -- Emma Rodriguez - Fri-Sat only
(4, 'Basic', '2025-07-25', '2025-07-27', 49.99),    -- James Wilson - Full weekend
(7, 'Premium', '2025-07-25', '2025-07-27', 99.99),  -- Amanda Brown - Premium full weekend
(8, 'Basic', '2025-07-25', '2025-07-26', 49.99),    -- Chris Miller - Fri-Sat only
(9, 'Basic', '2025-07-26', '2025-07-27', 49.99),    -- Jessica Taylor - Sat-Sun only
(10, 'Basic', '2025-07-25', '2025-07-25', 49.99),   -- Alex Martinez - Friday only

-- Main Wave (June 1-15) - 12 attendees camping
(11, 'Basic', '2025-07-25', '2025-07-27', 49.99),   -- Rachel Lee - Full weekend
(12, 'Premium', '2025-07-25', '2025-07-27', 99.99), -- Kevin Davis - Premium full weekend
(13, 'Basic', '2025-07-25', '2025-07-27', 49.99),   -- Megan White - Full weekend
(14, 'Premium', '2025-07-25', '2025-07-27', 99.99), -- Ryan Thomas - Premium full weekend
(15, 'Basic', '2025-07-25', '2025-07-26', 49.99),   -- Lauren Moore - Fri-Sat only
(16, 'Basic', '2025-07-26', '2025-07-27', 49.99),   -- Jordan Clark - Sat-Sun only
(18, 'Basic', '2025-07-25', '2025-07-27', 49.99),   -- Tyler Harris - Full weekend
(19, 'Basic', '2025-07-26', '2025-07-27', 49.99),   -- Sophia Lewis - Sat-Sun only
(21, 'Premium', '2025-07-25', '2025-07-27', 99.99), -- Ashley Young - Premium full weekend
(22, 'Basic', '2025-07-25', '2025-07-26', 49.99),   -- Matthew King - Fri-Sat only
(24, 'Basic', '2025-07-27', '2025-07-27', 49.99),   -- Joshua Green - Sunday only
(25, 'Premium', '2025-07-25', '2025-07-27', 99.99), -- Victoria Adams - Premium full weekend

-- Late Bookings (June 16-30) - 10 attendees camping
(26, 'Basic', '2025-07-25', '2025-07-27', 49.99),   -- Andrew Nelson - Full weekend
(27, 'Basic', '2025-07-26', '2025-07-27', 49.99),   -- Hannah Baker - Sat-Sun only
(28, 'Premium', '2025-07-25', '2025-07-26', 99.99), -- Daniel Carter - Premium Fri-Sat
(29, 'Basic', '2025-07-25', '2025-07-25', 49.99),   -- Isabella Mitchell - Friday only
(30, 'Basic', '2025-07-26', '2025-07-27', 49.99),   -- Nicholas Perez - Sat-Sun only
(31, 'Premium', '2025-07-25', '2025-07-27', 99.99), -- Grace Roberts - Premium full weekend
(32, 'Basic', '2025-07-25', '2025-07-27', 49.99),   -- Justin Turner - Full weekend
(33, 'Basic', '2025-07-26', '2025-07-26', 49.99),   -- Natalie Phillips - Saturday only
(35, 'Premium', '2025-07-27', '2025-07-27', 99.99), -- Chloe Parker - Premium Sunday only
(36, 'Basic', '2025-07-25', '2025-07-27', 49.99),   -- Patrick Evans - Full weekend

-- Last Minute (July) - 8 attendees camping
(37, 'Basic', '2025-07-25', '2025-07-25', 49.99),   -- Zoe Edwards - Friday only
(38, 'Basic', '2025-07-26', '2025-07-27', 49.99),   -- Adam Collins - Sat-Sun only
(39, 'Basic', '2025-07-25', '2025-07-26', 49.99),   -- Lily Stewart - Fri-Sat only
(40, 'Premium', '2025-07-25', '2025-07-27', 99.99), -- Nathan Sanchez - Premium full weekend
(41, 'Basic', '2025-07-26', '2025-07-27', 49.99),   -- Madison Morris - Sat-Sun only
(43, 'Basic', '2025-07-27', '2025-07-27', 49.99),   -- Avery Reed - Sunday only
(44, 'Basic', '2025-07-25', '2025-07-27', 49.99),   -- Kyle Cook - Full weekend
(47, 'Basic', '2025-07-25', '2025-07-27', 49.99);   -- Hailey Murphy - Full weekend

INSERT INTO Personal_Schedule (Attendee_id, Performance_id) VALUES
-- Sarah Johnson (1) - Eclectic taste, early planner
(1, 1), (1, 6), (1, 15), (1, 22), (1, 25), (1, 29),

-- Mike Chen (2) - VIP experience, prefers headliners
(2, 1), (2, 11), (2, 15), (2, 18), (2, 22), (2, 25),

-- Emma Rodriguez (3) - Rock focused
(3, 1), (3, 11), (3, 20), (3, 27), (3, 29), (3, 32),

-- James Wilson (4) - Electronic and dance
(4, 6), (4, 7), (4, 16), (4, 19), (4, 26), (4, 34),

-- Lisa Garcia (5) - Pop and mainstream
(5, 5), (5, 10), (5, 17), (5, 23), (5, 30), (5, 35),

-- David Kim (6) - Chill and acoustic
(6, 5), (6, 9), (6, 12), (6, 13), (6, 21), (6, 28),

-- Amanda Brown (7) - VIP, diverse tastes
(7, 2), (7, 8), (7, 14), (7, 21), (7, 27), (7, 33),

-- Chris Miller (8) - Metal and hard rock
(8, 3), (8, 11), (8, 20), (8, 24), (8, 27), (8, 32),

-- Jessica Taylor (9) - Weekend warrior (Sat-Sun pass)
(9, 15), (9, 16), (9, 18), (9, 22), (9, 25), (9, 30),

-- Alex Martinez (10) - Sunday only attendee
(10, 22), (10, 23), (10, 25), (10, 26), (10, 28), (10, 35),

-- Rachel Lee (11) - Group planner (bought 3 tickets)
(11, 1), (11, 6), (11, 15), (11, 19), (11, 22), (11, 25),

-- Kevin Davis (12) - Saturday focused
(12, 15), (12, 16), (12, 18), (12, 20), (12, 21), (12, 33),

-- Megan White (13) - Well-rounded weekend
(13, 2), (13, 7), (13, 15), (13, 22), (13, 27), (13, 34),

-- Ryan Thomas (14) - VIP, premium experiences
(14, 1), (14, 11), (14, 15), (14, 18), (14, 22), (14, 25),

-- Lauren Moore (15) - Friday-Saturday only
(15, 1), (15, 6), (15, 11), (15, 15), (15, 18), (15, 20),

-- Jordan Clark (16) - Saturday-Sunday only
(16, 15), (16, 16), (16, 18), (16, 22), (16, 25), (16, 30),

-- Olivia Anderson (17) - Sunday VIP
(17, 22), (17, 23), (17, 25), (17, 26), (17, 28), (17, 35),

-- Tyler Harris (18) - Last minute, packed schedule
(18, 1), (18, 6), (18, 11), (18, 15), (18, 18), (18, 22), (18, 25), (18, 29),

-- Sophia Lewis (19) - Indie and alternative
(19, 2), (19, 10), (19, 16), (19, 23), (19, 29), (19, 34),

-- Brandon Walker (20) - Friday only
(20, 1), (20, 6), (20, 8), (20, 11), (20, 12), (20, 14),

-- Ashley Young (21) - Electronic enthusiast
(21, 6), (21, 7), (21, 16), (21, 19), (21, 26), (21, 34),

-- Matthew King (22) - VIP Saturday
(22, 15), (22, 16), (22, 18), (22, 20), (22, 21), (22, 33),

-- Emily Scott (23) - Saturday-Sunday pass
(23, 15), (23, 16), (23, 18), (23, 22), (23, 25), (23, 30),

-- Joshua Green (24) - Sunday only
(24, 22), (24, 23), (24, 25), (24, 26), (24, 28), (24, 35),

-- Victoria Adams (25) - Premium everything
(25, 1), (25, 11), (25, 15), (25, 18), (25, 22), (25, 25),

-- Andrew Nelson (26) - Rock and metal
(26, 1), (26, 11), (26, 20), (26, 27), (26, 29), (26, 32),

-- Hannah Baker (27) - Saturday-Sunday
(27, 15), (27, 16), (27, 18), (27, 22), (27, 25), (27, 30),

-- Daniel Carter (28) - VIP Friday
(28, 1), (28, 6), (28, 8), (28, 11), (28, 12), (28, 14),

-- Isabella Mitchell (29) - Friday only
(29, 1), (29, 6), (29, 8), (29, 11), (29, 12), (29, 14),

-- Nicholas Perez (30) - Diverse weekend
(30, 2), (30, 7), (30, 15), (30, 22), (30, 27), (30, 34),

-- Grace Roberts (31) - VIP all weekend
(31, 1), (31, 11), (31, 15), (31, 18), (31, 22), (31, 25),

-- Justin Turner (32) - Chill and relaxed
(32, 5), (32, 9), (32, 12), (32, 13), (32, 21), (32, 28),

-- Natalie Phillips (33) - Saturday only
(33, 15), (33, 16), (33, 18), (33, 20), (33, 21), (33, 33),

-- Aaron Campbell (34) - Sunday only
(34, 22), (34, 23), (34, 25), (34, 26), (34, 28), (34, 35),

-- Chloe Parker (35) - VIP Sunday
(35, 22), (35, 23), (35, 25), (35, 26), (35, 28), (35, 35),

-- Patrick Evans (36) - Well-planned weekend
(36, 2), (36, 7), (36, 15), (36, 22), (36, 27), (36, 34),

-- Zoe Edwards (37) - Friday only, group
(37, 1), (37, 6), (37, 8), (37, 11), (37, 12), (37, 14),

-- Adam Collins (38) - Saturday-Sunday
(38, 15), (38, 16), (38, 18), (38, 22), (38, 25), (38, 30),

-- Lily Stewart (39) - Friday-Saturday
(39, 1), (39, 6), (39, 11), (39, 15), (39, 18), (39, 20),

-- Nathan Sanchez (40) - Premium VIP
(40, 1), (40, 11), (40, 15), (40, 18), (40, 22), (40, 25),

-- Madison Morris (41) - Saturday only
(41, 15), (41, 16), (41, 18), (41, 20), (41, 21), (41, 33),

-- Carlos Rogers (42) - VIP Friday
(42, 1), (42, 6), (42, 8), (42, 11), (42, 12), (42, 14),

-- Avery Reed (43) - Sunday only
(43, 22), (43, 23), (43, 25), (43, 26), (43, 28), (43, 35),

-- Kyle Cook (44) - Full weekend enthusiast
(44, 1), (44, 6), (44, 11), (44, 15), (44, 18), (44, 22), (44, 25), (44, 29),

-- Aria Morgan (45) - Saturday-Sunday
(45, 15), (45, 16), (45, 18), (45, 22), (45, 25), (45, 30),

-- Peter Bell (46) - VIP weekend
(46, 1), (46, 11), (46, 15), (46, 18), (46, 22), (46, 25),

-- Hailey Murphy (47) - Camping, full weekend
(47, 1), (47, 6), (47, 11), (47, 15), (47, 18), (47, 22), (47, 25), (47, 29),

-- Sean Cooper (48) - Saturday only
(48, 15), (48, 16), (48, 18), (48, 20), (48, 21), (48, 33),

-- Eleanor Richardson (49) - Friday only
(49, 1), (49, 6), (49, 8), (49, 11), (49, 12), (49, 14),

-- Logan Cox (50) - Last minute VIP Sunday
(50, 22), (50, 23), (50, 25), (50, 26), (50, 28), (50, 35); 


--Querying
--Attendee requirements
    --Access information on non-musical entertainment
SELECT
    *
FROM Entertainment_venue
ORDER BY Venue_type;

    --Create a personalized schedule from the line-up
SELECT 
    A.name As Artist, S.Name As Stage, P.Performance_date, P.Start_time, P.End_time
FROM Personal_Schedule PS
JOIN Performance P ON PS.Performance_id = P.Performance_id
JOIN Artist A ON P.Artist_id = A.Artist_id
JOIN Stage S ON P.stage_id = S.stage_id
WHERE PS.Attendee_id = 2 --By altering the Attendee_id you can display the schedule for the attendee in question.
ORDER BY P.Performance_date, P.Start_time;

    --Full Festial Lineup
SELECT 
    P.Performance_id, P.Performance_date AS Date, P.start_time AS Start_Time, A.name AS Artist, S.name AS Stage
FROM Performance P
JOIN Artist A ON P.Artist_id = A.Artist_id 
JOIN Stage S ON P.Stage_id = S.Stage_id
ORDER BY P.Performance_date, P.Start_time, A.name;

--Artist Requirement
SELECT 
    S.name AS Stage, P.Performance_date AS Date, P.Start_time AS Start, P.End_time AS End
FROM Performance P
JOIN Stage S ON P.Stage_id = S.Stage_id
WHERE P.Artist_id in (116, 118)
ORDER BY Date, Start;

--Organisers Requirements
    --Ticket sales
SELECT 
    tt.Type_name, COUNT(bli.Quantity) as Tickets_sold, 
    ROUND(SUM(bli.Quantity * tt.Price),2) as Total_revenue_per_ticket_type
FROM Booking_Line_Item bli
JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id
GROUP BY tt.Type_name
ORDER BY  Total_revenue_per_ticket_type DESC;

    --Attendeance patterns
SELECT 
    DATE(Booking_date) As Booking_Date, COUNT(*) AS Daily_Booking, SUM(Total_amount) AS Daily_revenue
FROM Booking
GROUP BY DATE(Booking_date)
ORDER BY Booking_Date;

    -- All artist performances with stage info
SELECT 
    a.Name as Artist, s.Name as Stage, p.Performance_date, p.Start_time, p.End_time
FROM Performance p
JOIN Artist a ON p.Artist_id = a.Artist_id
JOIN Stage s ON p.Stage_id = s.Stage_id
ORDER BY a.Name;

-- Top 10 most scheduled performances
SELECT 
    a.Name as Artist, s.Name as Stage, p.Performance_date, p.Start_time,
    COUNT(ps.Schedule_id) as times_scheduled
FROM Performance p
JOIN Artist a ON p.Artist_id = a.Artist_id
JOIN Stage s ON p.Stage_id = s.Stage_id
LEFT JOIN Personal_Schedule ps ON p.Performance_id = ps.Performance_id
GROUP BY p.Performance_id
ORDER BY times_scheduled DESC
LIMIT 10;

-- Camping revenue and occupancy
SELECT 
    Camping_type, COUNT(*) as reservations, 
    SUM(Price) as total_revenue,
    ROUND(AVG(julianday(End_date) - julianday(Start_date) + 1), 1) as avg_nights
FROM Camping_Reservation
GROUP BY Camping_type;

-- Bookings by hour of day to identify peak times
SELECT 
    strftime('%H:00', Booking_date) as hour_of_day, 
    COUNT(*) as bookings_count,
    ROUND(SUM(Total_amount), 2) as hourly_revenue
FROM Booking
GROUP BY strftime('%H', Booking_date)
ORDER BY hour_of_day;

--Artist playing multiple sets i.e 2 or more =
SELECT 
    A.name, COUNT(P.Performance_id) AS Performance_count
FROM Artist A 
JOIN Performance P
ON A.Artist_id = P.Artist_id
GROUP BY A.Artist_id, A.name
HAVING Performance_count > 1
ORDER BY Performance_count DESC;

-- How busy each stage is across the festival
SELECT
     s.Name as Stage, COUNT(p.Performance_id) as performance_count,
     GROUP_CONCAT(DISTINCT a.Genre) as genres_hosted
FROM Stage s
LEFT JOIN Performance p ON s.Stage_id = p.Stage_id
LEFT JOIN Artist a ON p.Artist_id = a.Artist_id
GROUP BY s.Stage_id, Stage
ORDER BY performance_count DESC;

-- Comprehensive festival overview
SELECT 
    (SELECT COUNT(*) FROM Attendee) as total_attendees,
    (SELECT SUM(Total_amount) FROM Booking) as total_revenue,
    (SELECT COUNT(*) FROM Performance) as total_performances,
    (SELECT COUNT(DISTINCT Artist_id) FROM Performance) as unique_artists,
    (SELECT COUNT(*) FROM Camping_Reservation) as camping_reservations;

-- Find scheduling conflicts for attendees
SELECT ps.Attendee_id, a.First_name, a.Last_name, 
       COUNT(DISTINCT p.Performance_id) as scheduled_performances,
       COUNT(DISTINCT p.Start_time || p.Performance_date) as unique_time_slots,
       CASE WHEN COUNT(DISTINCT p.Performance_id) != COUNT(DISTINCT p.Start_time || p.Performance_date) 
            THEN 'CONFLICTS' ELSE 'OK' END as status
FROM Personal_Schedule ps
JOIN Performance p ON ps.Performance_id = p.Performance_id
JOIN Attendee a ON ps.Attendee_id = a.Attendee_id
GROUP BY ps.Attendee_id;

--Testing

--FK Realationships
-- Test 1.1: Performance without valid Artist
SELECT 'FAIL: Performance without valid Artist' as test_name,
       COUNT(*) as issue_count 
FROM Performance p 
LEFT JOIN Artist a ON p.Artist_id = a.Artist_id 
WHERE a.Artist_id IS NULL;

-- Test 1.2: Performance without valid Stage
SELECT 'FAIL: Performance without valid Stage' as test_name,
       COUNT(*) as issue_count 
FROM Performance p 
LEFT JOIN Stage s ON p.Stage_id = s.Stage_id 
WHERE s.Stage_id IS NULL;

-- Test 1.3: Booking without valid Attendee
SELECT 'FAIL: Booking without valid Attendee' as test_name,
       COUNT(*) as issue_count 
FROM Booking b 
LEFT JOIN Attendee a ON b.Attendee_id = a.Attendee_id 
WHERE a.Attendee_id IS NULL;

-- Test 1.4: Booking_Line_Item without valid Booking
SELECT 'FAIL: Booking_Line_Item without valid Booking' as test_name,
       COUNT(*) as issue_count 
FROM Booking_Line_Item bli 
LEFT JOIN Booking b ON bli.Booking_id = b.Booking_id 
WHERE b.Booking_id IS NULL;

-- Test 1.5: Booking_Line_Item without valid Ticket_Type
SELECT 'FAIL: Booking_Line_Item without valid Ticket_Type' as test_name,
       COUNT(*) as issue_count 
FROM Booking_Line_Item bli 
LEFT JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id 
WHERE tt.Ticket_type_id IS NULL;

-- Test 1.6: Personal_Schedule without valid Attendee
SELECT 'FAIL: Personal_Schedule without valid Attendee' as test_name,
       COUNT(*) as issue_count 
FROM Personal_Schedule ps 
LEFT JOIN Attendee a ON ps.Attendee_id = a.Attendee_id 
WHERE a.Attendee_id IS NULL;

-- Test 1.7: Personal_Schedule without valid Performance
SELECT 'FAIL: Personal_Schedule without valid Performance' as test_name,
       COUNT(*) as issue_count 
FROM Personal_Schedule ps 
LEFT JOIN Performance p ON ps.Performance_id = p.Performance_id 
WHERE p.Performance_id IS NULL;

-- Test 1.8: Camping_Reservation without valid Attendee
SELECT 'FAIL: Camping_Reservation without valid Attendee' as test_name,
       COUNT(*) as issue_count 
FROM Camping_Reservation cr 
LEFT JOIN Attendee a ON cr.Attendee_id = a.Attendee_id 
WHERE a.Attendee_id IS NULL;

-- Test 1.9: Duplicate email addresses in Attendee
SELECT 'FAIL: Duplicate email addresses' as test_name,
       COUNT(*) as issue_count
FROM (
    SELECT Email, COUNT(*) as duplicate_count 
    FROM Attendee 
    GROUP BY Email 
    HAVING COUNT(*) > 1
);

-- Test 1.10: Stage double-booking (should be 0 due to unique index)
SELECT 'FAIL: Stage double-booking conflicts' as test_name,
       COUNT(*) as issue_count
FROM (
    SELECT Stage_id, Performance_date, Start_time, COUNT(*) as conflicts
    FROM Performance 
    GROUP BY Stage_id, Performance_date, Start_time 
    HAVING COUNT(*) > 1
);

-- Test 1.11: Duplicate personal schedules (same attendee + performance)
SELECT 'FAIL: Duplicate personal schedules' as test_name,
       COUNT(*) as issue_count
FROM (
    SELECT Attendee_id, Performance_id, COUNT(*) as duplicate_count
    FROM Personal_Schedule 
    GROUP BY Attendee_id, Performance_id 
    HAVING COUNT(*) > 1
);

--Business logic 
--Test 2.1: Invalide pass type in Ticket_type
SELECT 'FAIL: Invalid Pass_type value' as test_name,
        COUNT(*) as issue_count
FROM Ticket_type
WHERE Pass_type NOT IN  ('Festival_Day', 'Festival_Multi', 'VIP_Day', 'VIP_Multi', 'Camping');

-- Test 2.2: Single-day passes must have valid dates
SELECT 'FAIL: Single-day passes missing Valid_date' as test_name,
       COUNT(*) as issue_count
FROM Ticket_Type 
WHERE Pass_type IN ('Festival_Day', 'VIP_Day') AND Valid_date IS NULL;

-- Test 2.3: Multi-day passes should NOT have specific dates
SELECT 'FAIL: Multi-day passes with specific Valid_date' as test_name,
       COUNT(*) as issue_count
FROM Ticket_Type 
WHERE Pass_type IN ('Festival_Multi', 'VIP_Multi', 'Camping') AND Valid_date IS NOT NULL;

-- Test 2.4: Performance time validation (end time after start time)
SELECT 'FAIL: Performance end time before/equal to start time' as test_name,
       COUNT(*) as issue_count
FROM Performance 
WHERE End_time <= Start_time;

-- Test 2.5: Performance dates within festival range (July 25-27, 2025)
SELECT 'FAIL: Performances outside festival dates' as test_name,
       COUNT(*) as issue_count
FROM Performance 
WHERE Performance_date NOT BETWEEN '2025-07-25' AND '2025-07-27';

-- Test 2.6: Performance times within reasonable hours (noon to midnight)
SELECT 'FAIL: Performances outside reasonable hours' as test_name,
       COUNT(*) as issue_count
FROM Performance 
WHERE Start_time < '12:00' OR End_time > '23:59';

-- Test 2.7: Camping date validation (end date not before start date)
SELECT 'FAIL: Camping end date before start date' as test_name,
       COUNT(*) as issue_count
FROM Camping_Reservation 
WHERE End_date < Start_date;

-- Test 2.8: Camping within festival dates
SELECT 'FAIL: Camping outside festival dates' as test_name,
       COUNT(*) as issue_count
FROM Camping_Reservation 
WHERE Start_date < '2025-07-25' OR End_date > '2025-07-27';

-- Test 2.9: Valid camping types only
SELECT 'FAIL: Invalid camping types' as test_name,
       COUNT(*) as issue_count
FROM Camping_Reservation 
WHERE Camping_type NOT IN ('Basic', 'Premium');

--Data completness
-- Test 3.1: NULL values in critical Artist fields
SELECT 'FAIL: Artist without name' as test_name,
       COUNT(*) as issue_count
FROM Artist 
WHERE Name IS NULL OR Name = '';

-- Test 3.2: NULL values in critical Performance fields
SELECT 'FAIL: Performance missing required data' as test_name,
       COUNT(*) as issue_count
FROM Performance 
WHERE Performance_date IS NULL OR Start_time IS NULL OR End_time IS NULL;

-- Test 3.3: NULL values in critical Attendee fields
SELECT 'FAIL: Attendee without email or name' as test_name,
       COUNT(*) as issue_count
FROM Attendee 
WHERE Email IS NULL OR First_name IS NULL OR Last_name IS NULL;

-- Test 3.4: Expected artist count (should be 42)
SELECT 'FAIL: Unexpected artist count' as test_name,
       CASE 
           WHEN COUNT(*) = 42 THEN 0
           ELSE 1
       END as issue_count
FROM Artist;

-- Test 3.5: Expected attendee count (should be 50)
SELECT 'FAIL: Unexpected attendee count' as test_name,
       CASE 
           WHEN COUNT(*) = 50 THEN 0
           ELSE 1
       END as issue_count
FROM Attendee;

-- Test 3.6: Expected performance count (should be reasonable)
SELECT 'FAIL: Too few performances' as test_name,
       CASE 
           WHEN COUNT(*) >= 30 THEN 0  -- At least 30 performances
           ELSE 1
       END as issue_count
FROM Performance;

-- Test 3.7: Expected stage count (should be 5)
SELECT 'FAIL: Unexpected stage count' as test_name,
       CASE 
           WHEN COUNT(*) = 5 THEN 0
           ELSE 1
       END as issue_count
FROM Stage;

--Test 3.8: Expected ticket-type count (should be 12)
SELECT 'FAIL: Unexpected ticket type count' as test_name,
       CASE 
           WHEN COUNT(*) = 12 THEN 0
           ELSE 1
       END as issue_count
FROM Ticket_Type;

--Relationship validation
-- Test 4.1: Personal schedules for valid attendees/performances
SELECT 'FAIL: Invalid attendee in personal schedule' as test_name,
       COUNT(*) as issue_count
FROM Personal_Schedule ps
LEFT JOIN Attendee a ON ps.Attendee_id = a.Attendee_id
WHERE a.Attendee_id IS NULL;

-- Test 4.2: Personal schedules for valid performances
SELECT 'FAIL: Invalid performance in personal schedule' as test_name,
       COUNT(*) as issue_count
FROM Personal_Schedule ps
LEFT JOIN Performance p ON ps.Performance_id = p.Performance_id
WHERE p.Performance_id IS NULL;

-- Test 4.3: Booking amounts math line item alulations 
SELECT 'FAIL: Booking total mismatch with line items' as test_name,    --Issue identified--
       COUNT(*) as issue_count
FROM (
    SELECT b.Booking_id, b.Total_amount, 
           SUM(bli.Quantity * tt.Price) as calculated_total
    FROM Booking b
    JOIN Booking_Line_Item bli ON b.Booking_id = bli.Booking_id
    JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id
    GROUP BY b.Booking_id
    HAVING ABS(b.Total_amount - SUM(bli.Quantity * tt.Price)) > 0.01
);

-- Test 4.4: Camping attendees also have ticket bookings
SELECT 'FAIL: Camping attendees without ticket bookings' as test_name,
       COUNT(*) as issue_count
FROM Camping_Reservation cr
LEFT JOIN Booking b ON cr.Attendee_id = b.Attendee_id
WHERE b.Booking_id IS NULL;

-- Test 4.5: Artists with performances exist
SELECT 'FAIL: Performances for non-existent artists' as test_name,
       COUNT(*) as issue_count
FROM Performance p
LEFT JOIN Artist a ON p.Artist_id = a.Artist_id
WHERE a.Artist_id IS NULL;

-- Test 4.6: All ticket types are actually being sold
SELECT 'FAIL: Ticket types with no sales' as test_name,
       COUNT(*) as issue_count
FROM Ticket_Type tt
LEFT JOIN Booking_Line_Item bli ON tt.Ticket_type_id = bli.Ticket_type_id
WHERE bli.Line_item_id IS NULL;

-- Addressing Test 4.3
-- Show ALL bookings with their calculated totals vs stored totals
SELECT 
    b.Booking_id,
    b.Attendee_id,
    a.First_name || ' ' || a.Last_name as Attendee_Name,
    b.Total_amount as stored_total,
    ROUND(SUM(bli.Quantity * tt.Price), 2) as calculated_total,
    ROUND(ABS(b.Total_amount - SUM(bli.Quantity * tt.Price)), 2) as difference
FROM Booking b
JOIN Attendee a ON b.Attendee_id = a.Attendee_id
JOIN Booking_Line_Item bli ON b.Booking_id = bli.Booking_id
JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id
GROUP BY b.Booking_id
HAVING ABS(b.Total_amount - SUM(bli.Quantity * tt.Price)) > 0.01
ORDER BY difference DESC;

SELECT * FROM Camping_Reservation WHERE Attendee_id = 37;

SELECT * FROM Booking_Line_Item
where Booking_id = 37; 

SELECT * FROM Booking WHERE Booking_id = 37;

INSERT INTO Booking_Line_Item (Booking_id, Ticket_type_id, Quantity)
VALUES (37, 11, 1);  -- Basic Camping

UPDATE Booking 
SET Total_amount = 229.97  -- $179.98 + $49.99
WHERE Booking_id = 37;


-- Test 5.1: Index utilization for critical queries
-- Check if queries use indexes properly

--Foreign key index tests 
EXPLAIN QUERY PLAN SELECT * FROM Performance WHERE Artist_id = 118;  -- Post Malogne
EXPLAIN QUERY PLAN SELECT * FROM Performance WHERE Stage_id = 1;
EXPLAIN QUERY PLAN SELECT * FROM Personal_Schedule WHERE Attendee_id = 1;  -- Sarah Johnson
EXPLAIN QUERY PLAN SELECT * FROM Booking_Line_Item WHERE Booking_id = 1;
EXPLAIN QUERY PLAN SELECT * FROM Booking_Line_Item WHERE Ticket_type_id = 1;
EXPLAIN QUERY PLAN SELECT * FROM Booking WHERE Attendee_id = 1; --*



--Common query pattern tests
EXPLAIN QUERY PLAN 
SELECT * FROM Performance WHERE Performance_date = '2025-07-25'; --SCAN Performance*--
EXPLAIN QUERY PLAN
SELECT * FROM Booking WHERE DATE(Booking_date) = '2025-06-01'; --SCAN BOOKING*--
EXPLAIN QUERY PLAN
SELECT * FROM Attendee WHERE Email = 'sarah.johnson@email.com'; --Using index--
EXPLAIN QUERY PLAN SELECT * FROM Attendee WHERE DATE(Created_date) = '2025-05-20'; --SCANS for first_name, last_name and created date
EXPLAIN QUERY PLAN SELECT * FROM Attendee WHERE Attendee_id = 1;
EXPLAIN QUERY PLAN  
SELECT * FROM Artist WHERE Genre = 'Rock'; --SCAN ARTIST--

--Complex but common joins
-- Complex but common joins
EXPLAIN QUERY PLAN
SELECT a.Name, p.Performance_date, p.Start_time
FROM Artist a
JOIN Performance p ON a.Artist_id = p.Artist_id
WHERE a.Artist_id = 118;

EXPLAIN QUERY PLAN
SELECT a.First_name, b.Booking_date, bli.Quantity
FROM Attendee a
JOIN Booking b ON a.Attendee_id = b.Attendee_id
JOIN Booking_Line_Item bli ON b.Booking_id = bli.Booking_id
WHERE a.Attendee_id = 1;

--Addressing SCAN query--
--1. Create mixing index
CREATE INDEX idx_artist_genre ON Artist(Genre);

--2. Run Explain query plan--
-- Check if Genre query now uses index
EXPLAIN QUERY PLAN SELECT * FROM Artist WHERE Genre = 'Rock';

-- Check if date query can use index (with proper range query)
EXPLAIN QUERY PLAN 
SELECT * FROM Booking 
WHERE Booking_date >= '2025-06-01' AND Booking_date < '2025-06-02';

--3. Test query--
-- Test Genre index
SELECT 'Rock Artists' as category, COUNT(*) as count
FROM Artist WHERE Genre = 'Rock';

-- Test Date index with range query (not DATE() function)
SELECT 'June 1 Bookings' as category, COUNT(*) as count
FROM Booking 
WHERE Booking_date >= '2025-06-01' AND Booking_date < '2025-06-02';


-- Test 5.2 Complex Query Performance timing
-- Multi-table join with aggregation (timing start)
-- This query analyzes ticket sales patterns
EXPLAIN QUERY PLAN
SELECT 
    strftime('%Y-%m', b.Booking_date) as Month,
    tt.Type_name,
    SUM(bli.Quantity) as Tickets_Sold,
    ROUND(SUM(bli.Quantity * tt.Price), 2) as Revenue
FROM Booking_Line_Item bli
JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id
JOIN Booking b ON bli.Booking_id = b.Booking_id
-- Group by DATE() not strftime() - DATE() can use indexes better
GROUP BY DATE(b.Booking_date), tt.Type_name
ORDER BY DATE(b.Booking_date), Revenue DESC;
-- Execution time: 0.001-0.002 second i.e 1-2ms

--Fixing SCAN bli from Test 5.2
-- Drop existing single-column indexes if they exist (optional cleanup)
DROP INDEX IF EXISTS idx_line_item_booking_id;
DROP INDEX IF EXISTS idx_line_item_ticket_type_id;

CREATE INDEX idx_bli_optimized ON Booking_Line_Item(Booking_id, Ticket_type_id, Quantity);
CREATE INDEX idx_ticket_type ON Ticket_type(Ticket_type_id, Type_name, Pass_type);

EXPLAIN QUERY PLAN
SELECT 
    strftime('%Y-%m', b.Booking_date) as Month,
    tt.Type_name,
    SUM(bli.Quantity) as Tickets_Sold,
    ROUND(SUM(bli.Quantity * tt.Price), 2) as Revenue
FROM Booking_Line_Item bli
JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id
JOIN Booking b ON bli.Booking_id = b.Booking_id
-- Changed: Group by DATE() instead of strftime() for better index usage
GROUP BY DATE(b.Booking_date), tt.Type_name
ORDER BY DATE(b.Booking_date), Revenue DESC;
-- Execution time: 0.001-0.002 second i.e 1-2ms

-- Complex join analyzing artist popularity and scheduling patterns
EXPLAIN QUERY PLAN

SELECT 
    a.Name,
    a.Genre,
    COUNT(DISTINCT p.Performance_id) as Performance_Count,
    COUNT(DISTINCT ps.Attendee_id) as Attendee_Interest,
    GROUP_CONCAT(DISTINCT s.Name) as Stages_Played,
    MIN(p.Start_time) as Earliest_Set,
    MAX(p.Start_time) as Latest_Set
FROM Artist a
JOIN Performance p ON a.Artist_id = p.Artist_id
JOIN Stage s ON p.Stage_id = s.Stage_id
LEFT JOIN Personal_Schedule ps ON p.Performance_id = ps.Performance_id
WHERE p.Performance_date BETWEEN '2025-07-25' AND '2025-07-27'
GROUP BY a.Artist_id
HAVING Performance_Count > 1
ORDER BY Attendee_Interest DESC;
-- Execution time: 0.001-0.002 second i.e 1-2ms

--Test 5.3 Boundary Conditions: Festival schedule boundaries are correctly defined
SELECT MIN(Performance_date || ' ' || Start_time) as First_Performance
FROM Performance;

SELECT MAX(Performance_date || ' ' || Start_time) as Last_Performance
FROM Performance;

SELECT 'FAIL: Performances outside festival boundaries' as test_name,
       COUNT(*) as issue_count
FROM Performance
WHERE Performance_date < '2025-07-25' 
   OR Performance_date > '2025-07-27';

--Test 5.4 Ticket Prices: All prices are positive and within reasonable ranges

SELECT 'FAIL: Invalide ticket prices' AS test_name,
        COUNT(*) AS 'issue_count'
FROM Ticket_type
WHERE Price <= 0 OR Price is NULL;

SELECT MIN(Price)
FROM Ticket_type;

SELECT MAX(Price)
FROM Ticket_type;

SELECT 'WARNING: Unusual ticket prices' as test_name,
       Type_name, Price
FROM Ticket_Type
WHERE Price > 399.99 OR Price < 49.99;

-- 5.5 Valid date ranges for performances
-- Test 5.5.1: Performances within festival dates (July 25-27, 2025)
SELECT 'FAIL: Performance outside festival dates' AS test_name,
        COUNT(*) AS issue_count
FROM Performance
WHERE performance_date NOT BETWEEN '2025-07-25' AND '2025-07-27';

-- Test 5.5.2: Performance times within daily operating hours (12:00-23:59)
SELECT 'FAIL: Performances outside operating hours' as test_name,
       COUNT(*) as issue_count
FROM Performance
WHERE Start_time < '12:00' OR End_time > '23:59';

-- Test 5.5.3: Logical time sequencing (end time after start time)
SELECT 'FAIL: Performance time sequence errors' as test_name,
       COUNT(*) as issue_count
FROM Performance
WHERE End_time <= Start_time;

-- Test 5.5.4: Performance duration validation (reasonable set lengths)
SELECT 'WARNING: Unusual performance durations' as test_name,
       Performance_id,
       Artist_id,
       Start_time,
       End_time,
       CAST((julianday(End_time) - julianday(Start_time)) * 1440 AS INTEGER) as duration_minutes
FROM Performance
WHERE CAST((julianday(End_time) - julianday(Start_time)) * 1440 AS INTEGER) 
      NOT BETWEEN 30 AND 90; -- 30 min to 1 hour 30 min sets

-- 5.6 Email format validation (basic check)
-- Test 5.6.1: Basic email format validation (contains @ and domain)
SELECT 'FAIL: Invalid email format' as test_name,
       COUNT(*) as issue_count
FROM Attendee
WHERE Email NOT LIKE '%@%.%' 
   OR Email LIKE '% @%' 
   OR Email LIKE '@%'
   OR Email LIKE '%@'
   OR LENGTH(Email) - LENGTH(REPLACE(Email, '@', '')) > 1; -- Multiple @ symbols
   
-- Test 5.6.2: Missing or empty emails
SELECT 'FAIL: Missing email addresses' as test_name,
       COUNT(*) as issue_count
FROM Attendee
WHERE Email IS NULL OR TRIM(Email) = '';

-- Test 5.6.3: Check for obviously invalid email patterns
SELECT 'WARNING: Suspicious email patterns' as test_name,
       Attendee_id,
       Email
FROM Attendee
WHERE Email LIKE '%test%'
   OR Email LIKE '%example%'
   OR Email LIKE '%.local'
   OR Email NOT LIKE '%.com' 
      AND Email NOT LIKE '%.co.uk' 
      AND Email NOT LIKE '%.org'
      AND Email NOT LIKE '%.net'
      AND Email NOT LIKE '%.edu'
      AND Email NOT LIKE '%.gov';

-- 5.7 Quantity validation in line items
-- Test 5.7.1: Check for invalid quantities (zero or negative)
SELECT 'FAIL: Invalid line item quantities' as test_name,
       COUNT(*) as issue_count
FROM Booking_Line_Item
WHERE Quantity <= 0;

-- Test 5.7.2: Check for unusually large ticket quantities
SELECT 'WARNING: Unusually large ticket quantities' as test_name,
       bli.Booking_id,
       tt.Type_name,
       bli.Quantity
FROM Booking_Line_Item bli
JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id
WHERE bli.Quantity > 10;

-- Test 5.7.3: Validate booking totals match line item calculations (final verification)
SELECT 'FAIL: Booking total miscalculations' as test_name,
       COUNT(*) as issue_count
FROM (
    SELECT b.Booking_id,
           ABS(b.Total_amount - SUM(bli.Quantity * tt.Price)) as diff
    FROM Booking b
    JOIN Booking_Line_Item bli ON b.Booking_id = bli.Booking_id
    JOIN Ticket_Type tt ON bli.Ticket_type_id = tt.Ticket_type_id
    GROUP BY b.Booking_id
    HAVING ABS(b.Total_amount - SUM(bli.Quantity * tt.Price)) > 0.01
);

-- Test 5.7.4: Check for duplicate line items in same booking
SELECT 'FAIL: Duplicate ticket types in same booking' as test_name,
       COUNT(*) as issue_count
FROM (
    SELECT Booking_id, Ticket_type_id, COUNT(*) as dup_count
    FROM Booking_Line_Item
    GROUP BY Booking_id, Ticket_type_id
    HAVING COUNT(*) > 1
);


--last update 3:35 26/12/2025