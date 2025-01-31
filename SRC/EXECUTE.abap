  METHOD execute.

    DATA: ls_file_xstring TYPE xstring,
          ls_file_string  TYPE string,
          ls_solix_length TYPE i,
          ls_folder_id    TYPE soodk,
          ls_object_id    TYPE soodk,
          ls_object       TYPE borident,
          ls_objdata      TYPE sood1,
          ls_objhead      TYPE soli,
          ls_bcs          TYPE REF TO cx_bcs,
          ls_return       TYPE bapiret2,
          lo_message      TYPE REF TO /iwbep/cl_mgw_msg_container.

    DATA: lt_file_binary  TYPE solix_tab,
          lt_file_textab  TYPE soli_tab,
          lt_objhead      TYPE soli_tab,
          lt_bapirettab   TYPE bapirettab,
          lt_return       TYPE STANDARD TABLE OF bapiret2.

    me->base64_to_xstring(                            "Convert BASE64 in XSTRING
      EXPORTING
        file_base64  = data-base64
      IMPORTING
        file_xstring = ls_file_xstring
        bcs          = ls_bcs
    ).

    IF ls_bcs IS NOT INITIAL.

      me->treat_exception( EXPORTING exception  = ls_bcs
                           IMPORTING bapirettab = lt_bapirettab ).

      IF lt_bapirettab IS NOT INITIAL.

        TRY.
          ls_return = lt_bapirettab[ 1 ].
          APPEND ls_return TO lt_return.
        CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

      CLEAR: ls_bcs, lt_bapirettab, ls_return.

    ENDIF.

    me->xstring_to_binary(                            "Convert XSTRING in BINARY
      EXPORTING
        file_xstring    = ls_file_xstring
      IMPORTING
        solix_length    = ls_solix_length
        tab_file_binary = lt_file_binary
        bcs             = ls_bcs
    ).

    IF ls_bcs IS NOT INITIAL.

      me->treat_exception( EXPORTING exception  = ls_bcs
                           IMPORTING bapirettab = lt_bapirettab ).

      IF lt_bapirettab IS NOT INITIAL.

        TRY.
          ls_return = lt_bapirettab[ 1 ].
          APPEND ls_return TO lt_return.
        CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

      CLEAR: ls_bcs, lt_bapirettab, ls_return.

    ENDIF.

    me->binary_to_tabtext(                            "Convert BINARY in TABTEXT
      EXPORTING
        tab_file_binary = lt_file_binary
      IMPORTING
        tab_file_textab = lt_file_textab
        bcs             = ls_bcs
    ).

    IF ls_bcs IS NOT INITIAL.

      me->treat_exception( EXPORTING exception  = ls_bcs
                           IMPORTING bapirettab = lt_bapirettab ).

      IF lt_bapirettab IS NOT INITIAL.

        TRY.
          ls_return = lt_bapirettab[ 1 ].
          APPEND ls_return TO lt_return.
        CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

      CLEAR: ls_bcs, lt_bapirettab, ls_return.

    ENDIF.

    me->get_file_storage_address(                     "Get local that will insert file
      IMPORTING
        folder_id = ls_folder_id
        bcs       = ls_bcs
    ).

    IF ls_bcs IS NOT INITIAL.

      me->treat_exception( EXPORTING exception  = ls_bcs
                           IMPORTING bapirettab = lt_bapirettab ).

      IF lt_bapirettab IS NOT INITIAL.

        TRY.
          ls_return = lt_bapirettab[ 1 ].
          APPEND ls_return TO lt_return.
        CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

      CLEAR: ls_bcs, lt_bapirettab, ls_return.

    ENDIF.

    me->prepare_object(                               "Prepare objects to insert in GOS
      EXPORTING
        data          = data
        solix_length  = ls_solix_length
      IMPORTING
        tab_objhead   = lt_objhead
        object        = ls_object
        objdata       = ls_objdata
    ).

    me->insert_object_gos(                            "Insert file in GOS
      EXPORTING
        folder_id        = ls_folder_id
        object_hd_change = ls_objdata
      IMPORTING
        object_id        = ls_object_id
        bcs              = ls_bcs
      CHANGING
        tab_objhead      = lt_objhead
        tab_objcont      = lt_file_textab
    ).

    IF ls_bcs IS NOT INITIAL.

      me->treat_exception( EXPORTING exception  = ls_bcs
                           IMPORTING bapirettab = lt_bapirettab ).

      IF lt_bapirettab IS NOT INITIAL.

        TRY.
          ls_return = lt_bapirettab[ 1 ].
          APPEND ls_return TO lt_return.
        CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDIF.

      CLEAR: ls_bcs, lt_bapirettab, ls_return.

    ELSE.

      IF sy-subrc IS INITIAL.

        me->relation_create(                            "Create relation between file and document
          EXPORTING
            folder_id    = ls_folder_id
            object_id    = ls_object_id
            obj_rolea    = ls_object
        ).

        IF sy-subrc IS INITIAL.
          COMMIT WORK.
        ENDIF.

      ENDIF.

    ENDIF.

    IF lt_return IS NOT INITIAL.
      return = lt_return.
    ENDIF.

  ENDMETHOD.