-- Файл функцій functions.sql

-- Видалення функцій, якщо вони існують
DROP FUNCTION IF EXISTS CountMessagesInChat;
DROP FUNCTION IF EXISTS IsUserInChat;

-- Функція для отримання кількості повідомлень в чаті
DELIMITER //
CREATE FUNCTION CountMessagesInChat (p_ChatId INT) RETURNS INT
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE message_count INT;
    SELECT COUNT(*) INTO message_count FROM Messages
    WHERE ChatId = p_ChatId AND IsDeleted = FALSE;
    RETURN message_count;
END //
DELIMITER ;

-- Функція для перевірки, чи є користувач у чаті
DELIMITER //
CREATE FUNCTION IsUserInChat (p_UserId INT, p_ChatId INT) RETURNS BOOLEAN
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE user_exists BOOLEAN;
    SELECT EXISTS (
        SELECT 1 FROM ChatMembers WHERE UserId = p_UserId AND ChatId = p_ChatId
    ) INTO user_exists;
    RETURN user_exists;
END //
DELIMITER ;
