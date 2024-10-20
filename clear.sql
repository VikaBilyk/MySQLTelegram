SET FOREIGN_KEY_CHECKS = 0;

delete from Users where IsDeleted = true;
delete from Chats where IsDeleted = true;
delete from Messages where IsDeleted = true;
delete from Contacts where IsDeleted = true;
delete from Files where IsDeleted = true;
delete from Reactions where IsDeleted = true;
delete from `groups` where IsDeleted = true;

SET FOREIGN_KEY_CHECKS = 1;