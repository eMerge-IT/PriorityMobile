


CREATE TRIGGER [dbo].[TR_INSERT_PROVCODE]
ON [dbo].[ZEMG_PROVISIONING]
FOR INSERT
AS
BEGIN
UPDATE ZEMG_PROVISIONING SET PROVISION_STRING = (select SUBSTRING(CAST(NEWID() AS VARCHAR(36)),0,8))
END





