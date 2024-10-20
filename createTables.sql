drop table if exists Users;
create table Users (
    UserID int auto_increment primary key,
    UserName varchar(40) not null,
    Password varchar(255) not null,  -- Для зберігання хешу пароля
    Email varchar(100) not null unique,  -- Додано унікальність email
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (ModifiedBy) references Users (UserID),
    INDEX idx_isdeleted (IsDeleted)  -- Індекс для поля IsDeleted
);

drop table if exists Chats;
CREATE TABLE Chats (
    ChatID int auto_increment primary key,
    ChatName varchar(50) not null,
    IsGroup boolean,
    CreatedBy int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (CreatedBy) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID),
    INDEX idx_isdeleted_chats (IsDeleted)  -- Індекс для поля IsDeleted
);

drop table if exists Messages;
CREATE TABLE Messages (
    MessageId int auto_increment primary key,
    ChatId int,
    SenderId int,
    MessageText text not null,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (ChatId) references Chats (ChatID),
    foreign key (SenderId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID),
    INDEX idx_chatid (ChatId),  -- Індекси для зовнішніх ключів
    INDEX idx_senderid (SenderId),
    INDEX idx_isdeleted_messages (IsDeleted)  -- Індекс для поля IsDeleted
);

drop table if exists Contacts;
CREATE TABLE Contacts (
    ContactId int auto_increment primary key,
    UserId int,
    ContactUserId int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (UserId) references Users (UserID),
    foreign key (ContactUserId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID),
    INDEX idx_isdeleted_contacts (IsDeleted)  -- Індекс для поля IsDeleted
);

drop table if exists Files;
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
    foreign key (ModifiedBy) references Users (UserID),
    INDEX idx_messageid (MessageId),  -- Індекс для MessageId
    INDEX idx_isdeleted_files (IsDeleted)  -- Індекс для поля IsDeleted
);

drop table if exists Calls;
CREATE TABLE Calls (
    CallId int auto_increment primary key,
    CallerId int,
    ReceiverId int,
    StartTime datetime,  -- Додано StartTime
    EndTime datetime,  -- Додано EndTime
    LastModified datetime,
    ModifiedBy int,
    foreign key (CallerId) references Users (UserID),
    foreign key (ReceiverId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID)
);

drop table if exists Reactions;
CREATE TABLE Reactions (
    ReactionId int auto_increment primary key,
    MessageId int,
    UserId int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (MessageId) references Messages (MessageId),
    foreign key (UserId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID),
    INDEX idx_isdeleted_reactions (IsDeleted)  -- Індекс для поля IsDeleted
);

drop table if exists Settings;
CREATE TABLE Settings (
    SettingsId int auto_increment primary key,
    UserId int,
    ModifiedBy int,
    LastModified datetime,
    foreign key (UserId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID)
);

drop table if exists ChatMembers;
CREATE TABLE ChatMembers (
    ChatMemberId int auto_increment primary key,
    ChatId int,
    UserId int,
    LastModified datetime,
    ModifiedBy int,
    Role varchar(20) default 'member',  -- Додано поле Role
    foreign key (ChatId) references Chats (ChatID),
    foreign key (UserId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID)
);

drop table if exists UserStatus;
CREATE TABLE UserStatus (
    StatusId int auto_increment primary key,
    UserId int,
    StatusMessage text,
    LastModified datetime,
    ModifiedBy int,
    foreign key (UserId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID)
);

drop table if exists `groups`;
CREATE TABLE `groups` (
    GroupId int auto_increment primary key,
    GroupName varchar(50),
    CreatedById int,
    IsDeleted boolean default false,
    LastModified datetime,
    ModifiedBy int,
    foreign key (CreatedById) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID),
    INDEX idx_isdeleted_groups (IsDeleted)  -- Індекс для поля IsDeleted
);

drop table if exists GroupMembers;
CREATE TABLE GroupMembers (
    GroupMemberId int auto_increment primary key,
    GroupId int,
    UserId int,
    LastModified datetime,
    ModifiedBy int,
    foreign key (GroupId) references `groups` (GroupId),
    foreign key (UserId) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID)
);

drop table if exists Notifications;
CREATE TABLE Notifications (
    NotificationId int auto_increment primary key,
    UserId int,
    MessageId int,
    Notification varchar(50) not null,
    LastModified datetime,
    ModifiedBy int,
    foreign key (UserId) references Users (UserID),
    foreign key (MessageId) references Messages (MessageId),
    foreign key (ModifiedBy) references Users (UserID)
);

drop table if exists BotAccounts;
CREATE TABLE BotAccounts (
    BotId int auto_increment primary key,
    BotName varchar(50) not null,
    CreatedById int,
    IsActive boolean default true,
    LastModified datetime,
    ModifiedBy int,
    foreign key (CreatedById) references Users (UserID),
    foreign key (ModifiedBy) references Users (UserID)
);
