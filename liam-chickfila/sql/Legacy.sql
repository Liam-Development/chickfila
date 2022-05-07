INSERT INTO `jobs` (name, label, whitelisted) VALUES
	('chic','Chick Fil A', '1')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('chic',0,'recruit','Cashier',50,'{}','{}'),
	('chic',1,'cook','Line Cook',75,'{}','{}'),
	('chic',2,'lead','Shift Lead',100,'{}','{}'),
	('chic',3,'mgr','Manager',150,'{}','{}'),
	('chic',4,'boss','Boss',250,'{}','{}')
;

INSERT INTO `items` (`name`, `label`, `weight`) VALUES  
   ('chicfries', 'Fries', 1),
	('chicnuggets', 'Nuggets', 1),
	('chiccombo', 'Combo Meal', 1)
;