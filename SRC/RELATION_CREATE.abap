  method RELATION_CREATE.

    CONSTANTS: c_atta(4) TYPE c VALUE 'ATTA'.

    DATA: ls_folmen TYPE sofmk,
          ls_note   TYPE borident.

    IF folder_id IS NOT INITIAL AND
       object_id IS NOT INITIAL.

      ls_folmen-foltp = folder_id-objtp.
      ls_folmen-folyr = folder_id-objyr.
      ls_folmen-folno = folder_id-objno.

      ls_folmen-doctp = object_id-objtp.
      ls_folmen-docyr = object_id-objyr.
      ls_folmen-docno = object_id-objno.

    ENDIF.

    IF ls_folmen IS NOT INITIAL.

      ls_note-objtype = 'MESSAGE'.
      ls_note-objkey  = ls_folmen.

    ENDIF.

    CALL FUNCTION 'BINARY_RELATION_CREATE_COMMIT'
      EXPORTING
        obj_rolea      = obj_rolea
        obj_roleb      = ls_note
        relationtype   = c_atta
      EXCEPTIONS
        no_model       = 1
        internal_error = 2
        unknown        = 3
        others         = 4 .

    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  endmethod.