drop trigger if exists before_update_user;
drop trigger if exists before_update_users_modified_by;
drop trigger if exists before_delete_messages;
drop trigger if exists before_update_user_status;

CREATE TRIGGER before_update_user
BEFORE UPDATE ON UserProfiles
FOR EACH ROW
SET NEW.LastModified = NOW();


CREATE TRIGGER before_update_users_modified_by
BEFORE UPDATE ON UserProfiles
FOR EACH ROW
SET NEW.ModifiedBy = USER();  -- або вставте ідентифікатор користувача

CREATE TRIGGER before_delete_messages
BEFORE DELETE ON Messages
FOR EACH ROW
BEGIN
    DECLARE msg_count INT;
    SELECT COUNT(*) INTO msg_count FROM Reactions WHERE MessageId = OLD.MessageId;
    IF msg_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete message with existing reactions';
    END IF;
END;

CREATE TRIGGER before_update_user_status
BEFORE UPDATE ON UserStatus
FOR EACH ROW
BEGIN
    IF NEW.StatusMessage IS NULL THEN
        SET NEW.StatusMessage = 'No status';
    END IF;
END;





