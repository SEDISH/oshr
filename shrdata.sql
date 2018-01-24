--
-- Load patient identifier type
--

INSERT IGNORE INTO patient_identifier_type (name, description, format, check_digit, creator, date_created, required, format_description, validator, location_behavior, retired, retired_by, date_retired, retire_reason, uuid, uniqueness_behavior)
VALUES ('Code National', 'Code National du patient', NULL, '0','1','2017-05-25 11:43:24','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'9fb4533d-4fd5-4276-875b-2ab41597f5dd',NULL),
       ('iSantePlus ID', 'OpenMRS patient identifier, with check-digit', NULL, '1','1','2017-05-25 11:43:24','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'05a29f94-c0ed-11e2-94be-8c13b969e334',NULL),
       ('Biometrics Reference Code', "Code referencing a patient's record in an external biometrics system", NULL, '0','1','2017-05-25 11:43:24','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'e26ca279-8f57-44a5-9ed8-8cc16e90e559',NULL),
       ("Carte d'identification nationale", 'The Haiti national identification card is meant to replace the fiscal identity card.  Created 2005.', NULL, '0','1','2017-05-25 11:43:24','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'e797face-8e8f-11e7-bb31-be2e44b06b34',NULL),
       ('Code ST', 'Code ST du patient', NULL, '0','1','2017-05-25 11:43:24','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'d059f6d0-9e42-4760-8de1-8316b48bc5f1',NULL),
       ("Numéro d'identité fiscale (NIF)", 'The Haiti Tax Identification Number (NIF) is issued by the Direction Générale des Impôts (DGI) since 1987.  Any Haitian natural or legal person gets this 10-digit number.', NULL, '0','1','2017-05-25 11:43:24','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'e797f826-8e8f-11e7-bb31-be2e44b06b34',NULL);
