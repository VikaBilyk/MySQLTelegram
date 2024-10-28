drop view if exists ActiveUsers;
drop view if exists ChatList;
drop view if exists UserMessages;
drop view if exists UserContacts;
drop view if exists ChatMembersInfo;
drop view if exists ActiveNotifications;
drop view if exists FileList;
drop view if exists UserStatusHistory;

CREATE VIEW ActiveUsers AS
SELECT UserID, UserName, Email, LastModified
FROM UserProfiles
WHERE IsDeleted = false;

CREATE VIEW ChatList AS
SELECT
    Chats.ChatID,
    Chats.ChatName,
    UserProfiles.UserName AS CreatedBy
FROM Chats
JOIN UserProfiles ON Chats.CreatedBy = UserProfiles.UserID
WHERE Chats.IsDeleted = false;

CREATE VIEW UserMessages AS
SELECT
    Messages.MessageId,
    Messages.MessageText,
    Messages.LastModified,
    UserProfiles.UserName AS SenderName,
    Chats.ChatName
FROM Messages
JOIN UserProfiles ON Messages.SenderId = UserProfiles.UserID
JOIN Chats ON Messages.ChatId = Chats.ChatID
WHERE Messages.IsDeleted = false AND Chats.IsDeleted = false AND UserProfiles.IsDeleted=false;

CREATE VIEW UserContacts AS
SELECT
    UserProfiles.UserID AS UserId,
    UserProfiles.UserName AS UserName,
    Contacts.ContactUserId,
    ContactUsers.UserName AS ContactName
FROM Contacts
JOIN UserProfiles ON Contacts.UserId = UserProfiles.UserID
JOIN UserProfiles AS ContactUsers ON Contacts.ContactUserId = ContactUsers.UserID
WHERE Contacts.IsDeleted = false;

CREATE VIEW ChatMembersInfo AS
SELECT
    ChatMembers.ChatId,
    UserProfiles.UserName AS MemberName,
    ChatMembers.Role
FROM ChatMembers
JOIN UserProfiles ON ChatMembers.UserId = UserProfiles.UserID;

CREATE VIEW ActiveNotifications AS
SELECT
    Notifications.NotificationId,
    Notifications.Notification,
    UserProfiles.UserName AS RecipientName
FROM Notifications
JOIN UserProfiles ON Notifications.UserId = UserProfiles.UserID
WHERE Notifications.LastModified IS NOT NULL;

CREATE VIEW FileList AS
SELECT
    Files.FileId,
    Files.FileName,
    UserProfiles.UserName AS SenderName,
    Messages.MessageText
FROM Files
JOIN Messages ON Files.MessageId = Messages.MessageId
JOIN UserProfiles ON Messages.SenderId = UserProfiles.UserID
WHERE Files.IsDeleted = false;

CREATE VIEW UserStatusHistory AS
SELECT
    UserStatus.StatusId,
    UserProfiles.UserName,
    UserStatus.StatusMessage,
    UserStatus.LastModified
FROM UserStatus
JOIN UserProfiles ON UserStatus.UserId = UserProfiles.UserID
WHERE UserProfiles.IsDeleted = false;

-- 1. Перевірка ActiveUsers
SELECT * FROM ActiveUsers;

-- 2. Перевірка ChatList
SELECT * FROM ChatList;

-- 3. Перевірка UserMessages
SELECT * FROM UserMessages;

-- 4. Перевірка UserContacts
SELECT * FROM UserContacts;

-- 5. Перевірка ChatMembersInfo
SELECT * FROM ChatMembersInfo;

-- 6. Перевірка ActiveNotifications
SELECT * FROM ActiveNotifications;

-- 7. Перевірка FileList
SELECT * FROM FileList;

-- 8. Перевірка UserStatusHistory
SELECT * FROM UserStatusHistory;

-- Завершення тестування view
SELECT 'Перевірка view завершена.' AS ViewTestStatus;