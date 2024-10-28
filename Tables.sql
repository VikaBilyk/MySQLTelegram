DROP TABLE IF EXISTS BotAccounts;
DROP TABLE IF EXISTS Notifications;
DROP TABLE IF EXISTS GroupMembers;
DROP TABLE IF EXISTS `groups`;
DROP TABLE IF EXISTS UserStatus;
DROP TABLE IF EXISTS ChatMembers;
DROP TABLE IF EXISTS Settings;
DROP TABLE IF EXISTS Reactions;
DROP TABLE IF EXISTS Calls;
DROP TABLE IF EXISTS Files;
DROP TABLE IF EXISTS Contacts;
DROP TABLE IF EXISTS Messages;
DROP TABLE IF EXISTS Chats;
DROP TABLE IF EXISTS UserProfiles;

create table UserProfiles (
    UserID int auto_increment primary key,
    UserName varchar(40) not null,
    Password varchar(255) not null,  -- Для зберігання хешу пароля
    Email varchar(100) not null unique,  -- Додано унікальність email
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (ModifiedBy) references UserProfiles (UserID),
    INDEX idx_isdeleted (IsDeleted)  -- Індекс для поля IsDeleted
);

CREATE TABLE Chats (
    ChatID int auto_increment primary key,
    ChatName varchar(50) not null,
    IsGroup boolean,
    CreatedBy int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (CreatedBy) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID),
    INDEX idx_isdeleted_chats (IsDeleted)  -- Індекс для поля IsDeleted
);

CREATE TABLE Messages (
    MessageId int auto_increment primary key,
    ChatId int,
    SenderId int,
    MessageText text not null,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (ChatId) references Chats (ChatID),
    foreign key (SenderId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID),
    INDEX idx_chatid (ChatId),  -- Індекси для зовнішніх ключів
    INDEX idx_senderid (SenderId),
    INDEX idx_isdeleted_messages (IsDeleted)  -- Індекс для поля IsDeleted
);

CREATE TABLE Contacts (
    ContactId int auto_increment primary key,
    UserId int,
    ContactUserId int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (UserId) references UserProfiles (UserID),
    foreign key (ContactUserId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID),
    INDEX idx_isdeleted_contacts (IsDeleted)  -- Індекс для поля IsDeleted
);

CREATE TABLE Files (
    FileId int auto_increment primary key,
    MessageId int,
    FileName varchar(50) not null,
    FilePath varchar(100) not null,
    FileSize bigint,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (MessageId) references Messages (MessageId),
    foreign key (ModifiedBy) references UserProfiles (UserID),
    INDEX idx_messageid (MessageId),  -- Індекс для MessageId
    INDEX idx_isdeleted_files (IsDeleted)  -- Індекс для поля IsDeleted
);

CREATE TABLE Calls (
    CallId int auto_increment primary key,
    CallerId int,
    ReceiverId int,
    StartTime datetime,  -- Додано StartTime
    EndTime datetime,  -- Додано EndTime
    LastModified datetime,
    ModifiedBy int,
    foreign key (CallerId) references UserProfiles (UserID),
    foreign key (ReceiverId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID)
);

CREATE TABLE Reactions (
    ReactionId int auto_increment primary key,
    MessageId int,
    UserId int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (MessageId) references Messages (MessageId),
    foreign key (UserId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID),
    INDEX idx_isdeleted_reactions (IsDeleted)  -- Індекс для поля IsDeleted
);

CREATE TABLE Settings (
    SettingsId int auto_increment primary key,
    UserId int,
    ModifiedBy int,
    LastModified datetime,
    foreign key (UserId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID)
);

CREATE TABLE ChatMembers (
    ChatMemberId int auto_increment primary key,
    ChatId int,
    UserId int,
    LastModified datetime,
    ModifiedBy int,
    Role varchar(20) default 'member',  -- Додано поле Role
    foreign key (ChatId) references Chats (ChatID),
    foreign key (UserId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID)
);

CREATE TABLE UserStatus (
    StatusId int auto_increment primary key,
    UserId int,
    StatusMessage text,
    LastModified datetime,
    ModifiedBy int,
    foreign key (UserId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID)
);

CREATE TABLE `groups` (
    GroupId int auto_increment primary key,
    GroupName varchar(50),
    CreatedById int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (CreatedById) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID),
    INDEX idx_isdeleted_groups (IsDeleted)  -- Індекс для поля IsDeleted
);

CREATE TABLE GroupMembers (
    GroupMemberId int auto_increment primary key,
    GroupId int,
    UserId int,
    LastModified datetime,
    ModifiedBy int,
    foreign key (GroupId) references `groups` (GroupId),
    foreign key (UserId) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID)
);

CREATE TABLE Notifications (
    NotificationId int auto_increment primary key,
    UserId int,
    MessageId int,
    Notification varchar(50) not null,
    LastModified datetime,
    ModifiedBy int,
    foreign key (UserId) references UserProfiles (UserID),
    foreign key (MessageId) references Messages (MessageId),
    foreign key (ModifiedBy) references UserProfiles (UserID)
);

CREATE TABLE BotAccounts (
    BotId int auto_increment primary key,
    BotName varchar(50) not null,
    CreatedById int,
    IsActive boolean default true,
    LastModified datetime,
    ModifiedBy int,
    foreign key (CreatedById) references UserProfiles (UserID),
    foreign key (ModifiedBy) references UserProfiles (UserID)
);