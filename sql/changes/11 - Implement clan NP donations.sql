ALTER TABLE KNIGHTS ADD ClanPointFund int NOT NULL DEFAULT 0
GO

ALTER TABLE KNIGHTS_USER ADD nDonatedNP int DEFAULT 0
GO

CREATE PROCEDURE [DONATE_CLAN_POINTS]
	@strUserID			varchar(21),
	@sClanID			smallint,
	@nNationalPoints	int,
	@nRet				smallint
AS
BEGIN TRAN
	UPDATE KNIGHTS SET ClanPointFund += @nNationalPoints WHERE IDNum = @sClanID
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0) GOTO ERROR
	
	UPDATE KNIGHTS_USER SET nDonatedNP += @nNationalPoints WHERE strUserId = @strUserID AND sIDNum = @sClanID
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0) GOTO ERROR
	
	COMMIT TRAN
	SET @nRet =  0
	RETURN

ERROR:
	ROLLBACK TRAN
	SET @nRet =  1
	RETURN