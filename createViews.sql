CREATE VIEW ActiveUsers AS
SELECT UserID, UserName, Email, LastModified
FROM Users
WHERE IsDeleted = false;

CREATE VIEW ChatList AS
SELECT
    Chats.ChatID,
    Chats.ChatName,
    Users.UserName AS CreatedBy
FROM Chats
JOIN Users ON Chats.CreatedBy = Users.UserID
WHERE Chats.IsDeleted = false;

CREATE VIEW UserMessages AS
SELECT
    Messages.MessageId,
    Messages.MessageText,
    Messages.LastModified,
    Users.UserName AS SenderName,
    Chats.ChatName
FROM Messages
JOIN Users ON Messages.SenderId = Users.UserID
JOIN Chats ON Messages.ChatId = Chats.ChatID
WHERE Messages.IsDeleted = false AND Chats.IsDeleted = false AND Users.IsDeleted=false;

CREATE VIEW UserContacts AS
SELECT
    Users.UserID AS UserId,
    Users.UserName AS UserName,
    Contacts.ContactUserId,
    ContactUsers.UserName AS ContactName
FROM Contacts
JOIN Users ON Contacts.UserId = Users.UserID
JOIN Users AS ContactUsers ON Contacts.ContactUserId = ContactUsers.UserID
WHERE Contacts.IsDeleted = false;

CREATE VIEW ChatMembersInfo AS
SELECT
    ChatMembers.ChatId,
    Users.UserName AS MemberName,
    ChatMembers.Role
FROM ChatMembers
JOIN Users ON ChatMembers.UserId = Users.UserID;

CREATE VIEW ActiveNotifications AS
SELECT
    Notifications.NotificationId,
    Notifications.Notification,
    Users.UserName AS RecipientName
FROM Notifications
JOIN Users ON Notifications.UserId = Users.UserID
WHERE Notifications.LastModified IS NOT NULL;  

CREATE VIEW FileList AS
SELECT
    Files.FileId,
    Files.FileName,
    Users.UserName AS SenderName,
    Messages.MessageText
FROM Files
JOIN Messages ON Files.MessageId = Messages.MessageId
JOIN Users ON Messages.SenderId = Users.UserID
WHERE Files.IsDeleted = false;

CREATE VIEW UserStatusHistory AS
SELECT
    UserStatus.StatusId,
    Users.UserName,
    UserStatus.StatusMessage,
    UserStatus.LastModified
FROM UserStatus
JOIN Users ON UserStatus.UserId = Users.UserID
WHERE Users.IsDeleted = false;

