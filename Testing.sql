-- Додаємо адміністратора, якщо його ще немає
CALL AddUser('admin', 'adminpasswordhash', 'admin@example.com', NULL);

-- Отримуємо ID адміністратора
SET @AdminUserID = (SELECT UserID FROM UserProfiles WHERE UserName = 'admin');

-- Додаємо кілька користувачів
CALL AddUser('testuser1', 'passwordhash1', 'user1@example.com', @AdminUserID);
CALL AddUser('testuser2', 'passwordhash2', 'user2@example.com', @AdminUserID);

-- Перевіряємо, чи додалися користувачі
SELECT * FROM UserProfiles;

-- Перевірка унікальності email (цей запит має викликати помилку)
-- CALL AddUser('duplicateuser', 'passwordhash', 'user1@example.com', @AdminUserID);

-- Оновлюємо інформацію користувача
SET @UserIDToUpdate = (SELECT UserID FROM UserProfiles WHERE UserName = 'testuser1');
CALL UpdateUser(@UserIDToUpdate, 'updatedUserName1', 'updated_user1@example.com', @AdminUserID);

-- Перевіряємо, чи оновилися ім'я і email
SELECT UserID, UserName, Email FROM UserProfiles WHERE UserID = @UserIDToUpdate;

-- Додаємо новий чат
CALL AddChat('Test Chat', FALSE, @AdminUserID, NULL);

-- Перевіряємо, чи чат додано
SELECT * FROM Chats WHERE ChatName = 'Test Chat';

-- Додаємо повідомлення до чату
SET @ChatID = (SELECT ChatID FROM Chats WHERE ChatName = 'Test Chat');
CALL AddMessage(@ChatID, @AdminUserID, 'Hello, this is a test message.', @AdminUserID);

-- Перевіряємо, чи повідомлення додано
SELECT * FROM Messages WHERE ChatId = @ChatID;

-- Логічно видаляємо користувача
SET @UserIDToDelete = (SELECT UserID FROM UserProfiles WHERE UserName = 'testuser2');
CALL DeleteUser(@UserIDToDelete, @AdminUserID);

-- Перевіряємо, чи поле IsDeleted стало TRUE
SELECT UserID, UserName, IsDeleted FROM UserProfiles WHERE UserID = @UserIDToDelete;

-- Логічно видаляємо повідомлення
SET @MessageIDToDelete = (SELECT MessageId FROM Messages WHERE ChatId = @ChatID LIMIT 1);
CALL DeleteMessage(@MessageIDToDelete, @AdminUserID);

-- Перевіряємо, чи поле IsDeleted стало TRUE для повідомлення
SELECT MessageId, IsDeleted FROM Messages WHERE MessageId = @MessageIDToDelete;

-- Тестуємо тригери

-- 1. Оновлюємо користувача для перевірки тригера before_update_user
UPDATE UserProfiles SET UserName = 'admin_updated' WHERE UserID = @AdminUserID;

-- 2. Перевіряємо, чи поле LastModified оновлено
SELECT UserID, UserName, LastModified FROM UserProfiles WHERE UserID = @AdminUserID;

-- 3. Оновлюємо користувача для перевірки тригера before_update_users_modified_by
UPDATE UserProfiles SET Email = 'admin_updated@example.com' WHERE UserID = @AdminUserID;

-- 4. Перевіряємо, чи поле ModifiedBy оновлено
SELECT UserID, Email, ModifiedBy FROM UserProfiles WHERE UserID = @AdminUserID;

-- 5. Додаємо повідомлення для перевірки тригера before_delete_messages
CALL AddMessage(@ChatID, @AdminUserID, 'Test message with reactions', @AdminUserID);

-- Перевіряємо, чи повідомлення додано
SELECT MessageId, MessageText FROM Messages WHERE ChatId = @ChatID;

-- 7. Пробуємо видалити повідомлення з реакцією (очікується помилка)
-- DELETE FROM Messages WHERE MessageId = @MessageIDWithReaction;

-- 8. Перевіряємо статус видалення повідомлення

-- 9. Оновлюємо статус користувача для перевірки тригера before_update_user_status
CALL AddUser('status_user', 'passwordhash', 'status_user@example.com', @AdminUserID);
SET @UserStatusID = (SELECT UserID FROM UserProfiles WHERE UserName = 'status_user');

-- Додаємо запис про статус у UserStatus
INSERT INTO UserStatus (UserId, StatusMessage, LastModified) VALUES (@UserStatusID, NULL, NOW());

-- Оновлюємо статус користувача для перевірки тригера before_update_user_status
UPDATE UserStatus SET StatusMessage = NULL WHERE UserId = @UserStatusID;

-- 10. Перевіряємо, чи статус користувача оновлено
SELECT UserId, StatusMessage FROM UserStatus WHERE UserId = @UserStatusID;

-- Завершуємо
SELECT 'Перевірки завершені.' AS Status;


-- Тестування функцій CountMessagesInChat та IsUserInChat

-- 11. Використовуємо CountMessagesInChat для перевірки кількості повідомлень у чаті
SET @MessageCount = CountMessagesInChat(@ChatID);
SELECT @MessageCount AS MessageCountInChat;

-- 12. Додаємо користувача до чату та перевіряємо IsUserInChat
INSERT INTO ChatMembers (ChatId, UserId) VALUES (@ChatID, 2);

-- Використовуємо IsUserInChat для перевірки, чи є користувач у чаті
SET @IsUserInChat = IsUserInChat(2, @ChatID);
SELECT @IsUserInChat AS IsAdminInChat;

-- Перевірка результатів функцій
SELECT 'Тестування функцій завершено.' AS FunctionTestStatus;
