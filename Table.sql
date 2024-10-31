-- Очищення існуючих таблиць, якщо вони є
DROP TABLE IF EXISTS BotAccounts;
DROP TABLE IF EXISTS Notifications;
DROP TABLE IF EXISTS GroupMembers;
DROP TABLE IF EXISTS `Groups`;
DROP TABLE IF EXISTS UserStatus;
DROP TABLE IF EXISTS ChatMembers;
DROP TABLE IF EXISTS Settings;
DROP TABLE IF EXISTS ReactionTypes;
DROP TABLE IF EXISTS Reactions;
DROP TABLE IF EXISTS Calls;
DROP TABLE IF EXISTS Files;
DROP TABLE IF EXISTS Contacts;
DROP TABLE IF EXISTS Messages;
DROP TABLE IF EXISTS Chats;
DROP TABLE IF EXISTS UserProfiles;

-- Таблиця користувачів
CREATE TABLE UserProfiles (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(40) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID),
    INDEX idx_isdeleted (IsDeleted)
);

-- Таблиця чатів
CREATE TABLE Chats (
    ChatID INT AUTO_INCREMENT PRIMARY KEY,
    ChatName VARCHAR(50) NOT NULL,
    IsGroup BOOLEAN,
    CreatedBy INT,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (CreatedBy) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID),
    INDEX idx_isdeleted_chats (IsDeleted)
);

-- Зв'язок "багато до багатьох" між користувачами та чатами
CREATE TABLE ChatMembers (
    ChatMemberID INT AUTO_INCREMENT PRIMARY KEY,
    ChatID INT,
    UserID INT,
    Role VARCHAR(20) DEFAULT 'member',
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (ChatID) REFERENCES Chats (ChatID),
    FOREIGN KEY (UserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID)
);

-- Таблиця повідомлень
CREATE TABLE Messages (
    MessageID INT AUTO_INCREMENT PRIMARY KEY,
    ChatID INT,
    SenderID INT,
    MessageText TEXT NOT NULL,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (ChatID) REFERENCES Chats (ChatID),
    FOREIGN KEY (SenderID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID),
    INDEX idx_chatid (ChatID),
    INDEX idx_senderid (SenderID),
    INDEX idx_isdeleted_messages (IsDeleted)
);

-- Таблиця файлів для повідомлень
CREATE TABLE Files (
    FileID INT AUTO_INCREMENT PRIMARY KEY,
    MessageID INT,
    FileName VARCHAR(50) NOT NULL,
    FilePath VARCHAR(100) NOT NULL,
    FileSize BIGINT,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (MessageID) REFERENCES Messages (MessageID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID),
    INDEX idx_messageid (MessageID),
    INDEX idx_isdeleted_files (IsDeleted)
);

-- Таблиця контактів між користувачами (багато до багатьох)
CREATE TABLE Contacts (
    ContactID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ContactUserID INT,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (UserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ContactUserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID),
    INDEX idx_isdeleted_contacts (IsDeleted)
);

-- Таблиця дзвінків між користувачами
CREATE TABLE Calls (
    CallID INT AUTO_INCREMENT PRIMARY KEY,
    CallerID INT,
    ReceiverID INT,
    StartTime DATETIME,
    EndTime DATETIME,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (CallerID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ReceiverID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID)
);

-- Таблиця для типів реакцій
CREATE TABLE ReactionTypes (
    ReactionTypeID INT AUTO_INCREMENT PRIMARY KEY,
    ReactionName VARCHAR(50) NOT NULL UNIQUE
);

-- Таблиця для реакцій (багато до багатьох між користувачами і повідомленнями з типом реакції)
CREATE TABLE Reactions (
    ReactionID INT AUTO_INCREMENT PRIMARY KEY,
    MessageID INT,
    UserID INT,
    ReactionTypeID INT,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (MessageID) REFERENCES Messages (MessageID),
    FOREIGN KEY (UserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ReactionTypeID) REFERENCES ReactionTypes (ReactionTypeID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID),
    INDEX idx_isdeleted_reactions (IsDeleted)
);

-- Таблиця налаштувань користувачів
CREATE TABLE Settings (
    SettingsID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (UserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID)
);

-- Таблиця статусів користувачів
CREATE TABLE UserStatus (
    StatusID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    StatusMessage TEXT,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (UserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID)
);

-- Таблиця груп
CREATE TABLE `Groups` (
    GroupID INT AUTO_INCREMENT PRIMARY KEY,
    GroupName VARCHAR(50),
    CreatedByID INT,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (CreatedByID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID),
    INDEX idx_isdeleted_groups (IsDeleted)
);

-- Зв'язок "багато до багатьох" між групами та користувачами
CREATE TABLE GroupMembers (
    GroupMemberID INT AUTO_INCREMENT PRIMARY KEY,
    GroupID INT,
    UserID INT,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (GroupID) REFERENCES `Groups` (GroupID),
    FOREIGN KEY (UserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID)
);

-- Таблиця для сповіщень
CREATE TABLE Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    MessageID INT,
    Notification VARCHAR(50) NOT NULL,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (UserID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (MessageID) REFERENCES Messages (MessageID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID)
);

-- Таблиця для облікових записів ботів
CREATE TABLE BotAccounts (
    BotID INT AUTO_INCREMENT PRIMARY KEY,
    BotName VARCHAR(50) NOT NULL,
    CreatedByID INT,
    IsActive BOOLEAN DEFAULT TRUE,
    LastModified DATETIME,
    ModifiedBy INT,
    FOREIGN KEY (CreatedByID) REFERENCES UserProfiles (UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES UserProfiles (UserID)
);
