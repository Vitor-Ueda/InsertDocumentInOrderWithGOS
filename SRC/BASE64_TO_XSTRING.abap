METHOD base64_to_xstring.

    DATA: lv_file_xstring TYPE xstring.

    TRY.

      CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
        EXPORTING
          input    = file_base64
        IMPORTING
          output   = file_xstring
        EXCEPTIONS
          failed   = 1
          OTHERS   = 2 .

      CATCH cx_bcs INTO bcs.
    ENDTRY.

  ENDMETHOD.