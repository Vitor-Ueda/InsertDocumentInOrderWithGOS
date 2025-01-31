 METHOD get_file_storage_address.

    CONSTANTS: c_regio TYPE c VALUE 'B'.

    TRY.

      CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
        EXPORTING
          region                = c_regio
        IMPORTING
          folder_id             = folder_id
        EXCEPTIONS
          communication_failure = 1
          owner_not_exist       = 2
          system_failure        = 3
          x_error               = 4
          OTHERS                = 5 .

      CATCH cx_bcs INTO bcs.
    ENDTRY.

  ENDMETHOD.