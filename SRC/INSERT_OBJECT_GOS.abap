  METHOD insert_object_gos.

    CONSTANTS: c_ext(3) TYPE c VALUE 'EXT'.

    TRY.

      CALL FUNCTION 'SO_OBJECT_INSERT'
        EXPORTING
          folder_id                  = folder_id
          object_type                = c_ext
          object_hd_change           = object_hd_change
          owner                      = sy-uname
        IMPORTING
          object_id                  = object_id
        TABLES
          objcont                    = tab_objcont
          objhead                    = tab_objhead
        EXCEPTIONS
          active_user_not_exist      = 1
          communication_failure      = 2
          component_not_available    = 3
          dl_name_exist              = 4
          folder_not_exist           = 5
          folder_no_authorization    = 6
          object_type_not_exist      = 7
          operation_no_authorization = 8
          owner_not_exist            = 9
          parameter_error            = 10
          substitute_not_active      = 11
          substitute_not_defined     = 12
          system_failure             = 13
          x_error                    = 14
          OTHERS                     = 15 .

      CATCH cx_bcs INTO bcs.
    ENDTRY.


  ENDMETHOD.