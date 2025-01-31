method BINARY_TO_TABTEXT.

    TRY.

      CALL FUNCTION 'SO_SOLIXTAB_TO_SOLITAB'
        EXPORTING
          ip_solixtab = tab_file_binary
        IMPORTING
          ep_solitab  = tab_file_textab .

      CATCH cx_bcs INTO bcs.
    ENDTRY.

  endmethod.