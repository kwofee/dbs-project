DELIMITER //

CREATE PROCEDURE change_subsystem_leader(
    IN p_subsystem_name VARCHAR(255),
    IN p_new_leader_regno VARCHAR(255),
    IN p_project_name VARCHAR(255)
)
BEGIN
    -- Verify the new leader is part of the project
    IF EXISTS (
        SELECT 1 FROM works_on 
        WHERE registration_number = p_new_leader_regno 
        AND studproj_name = p_project_name
    ) THEN
        -- Update the subsystem leader
        UPDATE subsystem 
        SET leader_regno = p_new_leader_regno
        WHERE subsystem_name = p_subsystem_name 
        AND studproj_name = p_project_name;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student must be a member of the project';
    END IF;
END //

DELIMITER ;
