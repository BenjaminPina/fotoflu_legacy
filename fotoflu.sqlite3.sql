BEGIN TRANSACTION;
CREATE TABLE `selecciones` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`directorio`	INTEGER NOT NULL,
	`descripcion`	TEXT NOT NULL
);
CREATE TABLE `extensiones` (
	`indice`	INTEGER NOT NULL,
	`extension`	TEXT NOT NULL,
	`marca`	TEXT NOT NULL
);
CREATE TABLE "directorios" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`ruta`	TEXT NOT NULL DEFAULT '.'
);
CREATE TABLE "destinos" (
	`id`	INTEGER NOT NULL DEFAULT 0 UNIQUE,
	`descripcion`	TEXT NOT NULL,
	PRIMARY KEY(id)
);
CREATE TABLE "configuracion" (
	`directorio`	TEXT NOT NULL DEFAULT '.',
	`ventana`	INTEGER NOT NULL DEFAULT 0,
	`ext_raw`	INTEGER NOT NULL DEFAULT 1,
	`dest_raw`	INTEGER NOT NULL DEFAULT 3,
	`dest_jpg`	INTEGER NOT NULL DEFAULT 1,
	`dest_selectas`	INTEGER NOT NULL DEFAULT 2,
	`id`	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY(id)
);
CREATE TABLE "archivos" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`directorio`	INTEGER NOT NULL,
	`seleccion`	INTEGER NOT NULL DEFAULT 0,
	`nombre`	TEXT NOT NULL
);
INSERT INTO `extensiones` VALUES (1,'DNG','Adobe [dng]');
INSERT INTO `extensiones` VALUES (2,'CR2','Canon [cr2]');
INSERT INTO `extensiones` VALUES (3,'BAY','Casio [bay]');
INSERT INTO `extensiones` VALUES (4,'RAF','Fuji [raf]');
INSERT INTO `extensiones` VALUES (5,'DCR','Kodak [dcr]');
INSERT INTO `extensiones` VALUES (6,'MRW','Minolta [mrw]');
INSERT INTO `extensiones` VALUES (7,'NEF','Nikon [nef]');
INSERT INTO `extensiones` VALUES (8,'ORF','Olympus [orf]');
INSERT INTO `extensiones` VALUES (9,'RAW','Panasonic [raw]');
INSERT INTO `extensiones` VALUES (10,'PEF','Pentax [pef]');
INSERT INTO `extensiones` VALUES (11,'SRF','Sony [srf]');
INSERT INTO `destinos` VALUES (1,'raw');
INSERT INTO `destinos` VALUES (2,'jpg');
INSERT INTO `destinos` VALUES (3,'selectas');
INSERT INTO `destinos` VALUES (4,'procesadas');
INSERT INTO `destinos` VALUES (5,'retocadas');
INSERT INTO `destinos` VALUES (6,'selladas');
INSERT INTO `destinos` VALUES (7,'achicadas');
INSERT INTO `configuracion` VALUES ('.',1,2,1,2,3,1);
COMMIT;
