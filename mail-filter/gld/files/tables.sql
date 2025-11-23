CREATE TABLE `greylist` (
	`ip` CHAR( 39 ) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'IP of Sending Host',
	`sender` CHAR( 242 ) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'Address of Sender',
	`recipient` CHAR( 242 ) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'Address of Recipient',
	`first` INT( 11 ) NOT NULL DEFAULT '0' COMMENT 'Date, when this Sender has first been seen',
	`last` INT( 11 ) NOT NULL DEFAULT '0' COMMENT 'Date, when this sender has last been seen',
	`n` INT( 11 ) NOT NULL DEFAULT '0' COMMENT 'Sequence number',
	 PRIMARY KEY ( `ip` , `sender` , `recipient`  )
) ENGINE = MYISAM CHARACTER SET latin1 COLLATE latin1_general_ci COMMENT = 'GLD Greylist Table';

CREATE TABLE `whitelist` (
	`mail` CHAR( 242 ) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'Adress which is whitelisted',
	`comment` CHAR( 242 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'A comment, about why this adress is whitelisted',
	PRIMARY KEY ( `mail` )
) ENGINE = MYISAM CHARACTER SET latin1 COLLATE latin1_general_ci COMMENT = 'GLD Whitelist Table';
