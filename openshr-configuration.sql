--
-- OpenSHR configuration for integration with OpenHIM
--

--
-- NIST2010 Identifier
--

INSERT IGNORE INTO patient_identifier_type (name, description, format, check_digit, creator, date_created, required, format_description, validator, location_behavior, retired, retired_by, date_retired, retire_reason, uuid, uniqueness_behavior)
VALUES	('NIST2010','NIST2010 Identifier description',NULL,'0','1','2017-05-25 11:43:01','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'d8752f79-ab8d-4f4e-8531-4ba4957345de',NULL),
	('ECID','ECID description',NULL,'0','1','2017-05-25 11:43:24','0',NULL,NULL,NULL,'0',NULL,NULL,NULL,'dd3037f0-0653-4ed2-8999-18e1bbdfae24',NULL);

--
-- OpenSHR Configuration
--

INSERT INTO global_property
VALUES ('openhie-client.endpoint.pdq','ohie-il','Indicates the endpoint on which PDQ messages should be routed','2ee943c3-6567-4332-ba44-3fa5e5cb93a1',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('openhie-client.endpoint.pdq.port','8989','Indicates the port on which PDQ messages should be routed','167e2663-261a-4bce-b1ad-09ef4edc0494',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('openhie-client.endpoint.pix','ohie-il','Indicates the endpoint on which PIX messages should be routed','cbb85ce5-c181-4962-9ce4-021b22734297',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('openhie-client.endpoint.pix.port','8989','Indicates the port on which PIX messages should be routed','2b889f3c-c807-4800-997d-62a14db36a8f',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('openhie-client.endpoint.xds.registry','http://localhost:8010/axis2/services/xdsregistryb','Indicates the endpoint on which XDS Registry messages should be routed','a5fe8065-ec77-4b84-959c-ad8c5ebb114e',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('openhie-client.endpoint.xds.repository','http://localhost:8010/openmrs-standalone/ms/xdsrepository','Indicates the port on which XDS Repository messages should be routed','10a67d53-504a-48ad-83e8-1180f3f799d7',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('xds-b-repository.homeCommunituyId','1.3.6.1.4.1.21367.2010.1.2.2045','The id of the community within which this SHR operates','cae07f64-2034-456b-b88b-bb706638e320',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('xds-b-repository.xdsrepository.uniqueId','1.3.6.1.4.1.21367.2010.1.2.1125','The id of this XDSb repository.','59852a1a-cf55-42c4-8dd9-73cfaa79aedf',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('xds-b-repository.xdsregistry.url','http://localhost:8010/axis2/services/xdsregistryb','The url of the XDSb registry to use.','c92e9849-a677-4b86-b8be-5a0d2e470009',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('xds-b-repository.xdsregistry.url','http://localhost:8010/axis2/services/xdsregistryb','The url of the XDSb registry to use.','c92e9849-a677-4b86-b8be-5a0d2e470009',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);

INSERT INTO global_property
VALUES ('layout.address.format','<org.openmrs.layout.web.address.AddressTemplate>
     <nameMappings class="properties">
       <property name="address2" value="Ri / Nimewo Kay"/>
       <property name="address1" value="Lokalite"/>
       <property name="country" value="Peyi"/>
       <property name="stateProvince" value="Depatman"/>
       <property name="cityVillage" value="Komin"/>
       <property name="countyDistrict" value="Seksyon Riral"/>
     </nameMappings>
     <sizeMappings class="properties">
       <property name="address2" value="40"/>
       <property name="address1" value="40"/>
       <property name="country" value="40"/>
       <property name="stateProvince" value="40"/>
       <property name="cityVillage" value="40"/>
       <property name="countyDistrict" value="40"/>
     </sizeMappings>
     <lineByLineFormat>
       <string>country</string>
       <string>stateProvince</string>
       <string>cityVillage</string>
       <string>countyDistrict</string>
       <string>address1</string>
       <string>address2</string>
     </lineByLineFormat>
</org.openmrs.layout.web.address.AddressTemplate>','XML description of address formats','c1f22426-86e1-491f-b47b-4cccc78864be',NULL,NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE
  property_value=VALUES(property_value);
