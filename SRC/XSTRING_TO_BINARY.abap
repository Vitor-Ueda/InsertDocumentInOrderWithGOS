METHOD xstring_to_binary.

    TRY.

      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = file_xstring
        IMPORTING
          output_length = solix_length
        TABLES
          binary_tab    = tab_file_binary.

      CATCH cx_bcs INTO bcs.
    ENDTRY.

  ENDMETHOD.