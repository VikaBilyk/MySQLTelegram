-- Додаємо адміністратора, якщо його ще немає
CALL AddUser('admin', 'adminpasswordhash', 'admin@example.com', NULL);

-- Отримуємо ID адміністратора
SET @AdminUserID = (SELECT UserID FROM Users WHERE UserName = 'admin');

-- Додаємо кілька користувачів
CALL AddUser('testuser1', 'passwordhash1', 'user1@example.com', @AdminUserID);
CALL AddUser('testuser2', 'passwordhash2', 'user2@example.com', @AdminUserID);

-- Перевіряємо, чи додалися користувачі
SELECT * FROM Users;

-- Перевірка унікальності email (цей запит має викликати помилку)
# CALL AddUser('duplicateuser', 'passwordhash', 'user1@example.com', @AdminUserID);

-- Оновлюємо інформацію користувача
SET @UserIDToUpdate = (SELECT UserID FROM Users WHERE UserName = 'testuser1');
CALL UpdateUser(@UserIDToUpdate, 'updatedUserName1', 'updated_user1@example.com', @AdminUserID);

-- Перевіряємо, чи оновилися ім'я і email
SELECT UserID, UserName, Email FROM Users WHERE UserID = @UserIDToUpdate;

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
SET @UserIDToDelete = (SELECT UserID FROM Users WHERE UserName = 'testuser2');
CALL DeleteUser(@UserIDToDelete, @AdminUserID);

-- Перевіряємо, чи поле `IsDeleted` стало TRUE
SELECT UserID, UserName, IsDeleted FROM Users WHERE UserID = @UserIDToDelete;

-- Логічно видаляємо повідомлення
SET @MessageIDToDelete = (SELECT MessageId FROM Messages WHERE ChatId = @ChatID LIMIT 1);
CALL DeleteMessage(@MessageIDToDelete, @AdminUserID);

-- Перевіряємо, чи поле `IsDeleted` стало TRUE для повідомлення
SELECT MessageId, IsDeleted FROM Messages WHERE MessageId = @MessageIDToDelete;

-- Тестуємо тригери

-- 1. Оновлюємо користувача для перевірки тригера before_update_users
UPDATE Users SET UserName = 'admin_updated' WHERE UserID = @AdminUserID;

-- 2. Перевіряємо, чи поле LastModified оновлено
SELECT UserID, UserName, LastModified FROM Users WHERE UserID = @AdminUserID;

-- 3. Оновлюємо користувача для перевірки тригера before_update_users_modified_by
UPDATE Users SET Email = 'admin_updated@example.com' WHERE UserID = @AdminUserID;

-- 4. Перевіряємо, чи поле ModifiedBy оновлено
SELECT UserID, Email, ModifiedBy FROM Users WHERE UserID = @AdminUserID;

-- 5. Додаємо повідомлення для перевірки тригера before_delete_messages
CALL AddMessage(1, @AdminUserID, 'Test message with reactions', @AdminUserID);



-- 8. Перевіряємо статус видалення повідомлення
SELECT @DeleteMessageStatus AS DeleteStatus, COUNT(*) AS RemainingMessages FROM Messages;

-- 9. Оновлюємо статус користувача для перевірки тригера before_update_user_status
CALL AddUser('status_user', 'passwordhash', 'status_user@example.com', @AdminUserID);
SET @UserStatusID = (SELECT UserId FROM Users WHERE UserName = 'status_user');

UPDATE UserStatus SET StatusMessage = NULL WHERE UserId = @UserStatusID;

-- 10. Перевіряємо, чи статус користувача оновлено
SELECT UserId, StatusMessage FROM UserStatus WHERE UserId = @UserStatusID;

-- Завершуємо
SELECT 'Перевірки завершені.' AS Status;
