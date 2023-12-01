SET NOCOUNT ON 
SET XACT_ABORT ON

--Error Handling
DECLARE
     @v_vchErrorMessage NVARCHAR(4000)
    ,@v_nErrorSeverity  INT
    ,@v_nErrorLine      INT

--Local Variables    
DECLARE
     @v_nExpectedCount  INT = 0
    ,@v_nActualCount    INT = 0
    ,@v_vchCurrentDatetime VARCHAR(32) 

BEGIN TRY

    SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
    RAISERROR('%s - Script - Started', 0, 1, @v_vchCurrentDatetime) WITH NOWAIT

    /* Start - Set Expected Count Here */
    --
    --SET @v_nExpectedCount = 1
    --SELECT @v_nExpectedCount = COUNT(*) FROM dbo.t_whse
    --
    --
    /* End - Set Expected Count Here */

    SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
    RAISERROR('%s - Transaction - Started', 0, 1, @v_vchCurrentDatetime) WITH NOWAIT

    BEGIN TRANSACTION

    /* Start - Set DML Statement here */
    --
    --
    --
    --
    --
    -- r
    /* End - Set DML Statement here */
    
    SELECT @v_nActualCount = @@ROWCOUNT

    IF @v_nExpectedCount = @v_nActualCount
    BEGIN 
        COMMIT TRANSACTION
        SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
        RAISERROR('%s - Transaction - Committed', 0, 1, @v_vchCurrentDatetime) WITH NOWAIT
        SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
        RAISERROR('%s - Success - Expected Rows: %d - Actual Rows: %d', 0, 1, @v_vchCurrentDatetime, @v_nExpectedCount, @v_nActualCount) WITH NOWAIT
    END
    ELSE
    BEGIN
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION
        END
        SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121) 
        RAISERROR('%s - Transaction - Rollback', 0, 1, @v_vchCurrentDatetime) WITH NOWAIT
        SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
        RAISERROR('Failure - Expected Rows: %d - Actual Rows: %d', 16, 1, @v_nExpectedCount, @v_nActualCount) WITH NOWAIT
    END

    SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
    RAISERROR('%s - Script - End', 0, 1, @v_vchCurrentDatetime) WITH NOWAIT

END TRY
BEGIN CATCH

    SELECT 
         @v_vchErrorMessage = ERROR_MESSAGE()
        ,@v_nErrorSeverity = ERROR_SEVERITY()
        ,@v_nErrorLine = ERROR_LINE()
         
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION
        SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
        RAISERROR('%s - Transaction - Rollback', 16, 1, @v_vchCurrentDatetime) WITH NOWAIT
    END

    SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
    RAISERROR('%s - Error - ErrorMessage: %s - ErrorSeverity: %d - ErrorLine: %d', 16, 1, @v_vchCurrentDatetime, @v_vchErrorMessage, @v_nErrorSeverity, @v_nErrorLine)

    SELECT @v_vchCurrentDatetime = CONVERT(VARCHAR(32), GETDATE(), 121)
    RAISERROR('%s - Script - End', 0, 1, @v_vchCurrentDatetime) WITH NOWAIT

END CATCH 