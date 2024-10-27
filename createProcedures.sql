-- Файл процедур procedures.sql
drop procedure if exists AddUser;
drop procedure if exists DeleteUser;
drop procedure if exists UpdateUser;
drop procedure if exists AddMessage;
drop procedure if exists DeleteMessage;
drop procedure if exists AddChat;
-- Процедура для додавання користувача
DELIMITER //
CREATE PROCEDURE AddUser (
    IN p_UserName VARCHAR(40),
    IN p_Password VARCHAR(255),
    IN p_Email VARCHAR(100),
    IN p_ModifiedBy INT
)
BEGIN
    INSERT INTO Users (UserName, Password, Email, LastModified, ModifiedBy)
    VALUES (p_UserName, p_Password, p_Email, NOW(), p_ModifiedBy);
END //
DELIMITER ;

-- Процедура для логічного видалення користувача
DELIMITER //
CREATE PROCEDURE DeleteUser(IN p_UserId INT, IN p_ModifiedBy INT)
BEGIN
    UPDATE Users
    SET IsDeleted = TRUE,
        LastModified = NOW(),
        ModifiedBy = IFNULL(p_ModifiedBy, NULL)  -- Перевірка на NULL для ModifiedBy
    WHERE UserID = p_UserId;
END //
DELIMITER ;


-- Процедура для оновлення інформації про користувача
DELIMITER //
CREATE PROCEDURE UpdateUser (
    IN p_UserID INT,
    IN p_UserName VARCHAR(40),
    IN p_Email VARCHAR(100),
    IN p_ModifiedBy INT
)
BEGIN
    UPDATE Users
    SET UserName = p_UserName, Email = p_Email, LastModified = NOW(), ModifiedBy = p_ModifiedBy
    WHERE UserID = p_UserID;
END //
DELIMITER ;

-- Процедура для додавання повідомлення
DELIMITER //
CREATE PROCEDURE AddMessage (
    IN p_ChatId INT,
    IN p_SenderId INT,
    IN p_MessageText TEXT,
    IN p_ModifiedBy INT
)
BEGIN
    INSERT INTO Messages (ChatId, SenderId, MessageText, LastModified, ModifiedBy)
    VALUES (p_ChatId, p_SenderId, p_MessageText, NOW(), p_ModifiedBy);
END //
DELIMITER ;

-- Процедура для логічного видалення повідомлення
DELIMITER //
CREATE PROCEDURE DeleteMessage (
    IN p_MessageId INT,
    IN p_ModifiedBy INT
)
BEGIN
    UPDATE Messages
    SET IsDeleted = TRUE, LastModified = NOW(), ModifiedBy = p_ModifiedBy
    WHERE MessageId = p_MessageId;
END //
DELIMITER ;

-- Процедура для додавання нового чату
DELIMITER //
CREATE PROCEDURE AddChat (
    IN p_ChatName VARCHAR(50),
    IN p_IsGroup BOOLEAN,
    IN p_CreatedBy INT,
    IN p_ModifiedBy INT
)
BEGIN
    INSERT INTO Chats (ChatName, IsGroup, CreatedBy, LastModified, ModifiedBy)
    VALUES (p_ChatName, p_IsGroup, p_CreatedBy, NOW(), p_ModifiedBy);
END //
DELIMITER ;

