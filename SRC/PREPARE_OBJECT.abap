  METHOD prepare_object.

    CONSTANTS: c_bus_pc(7) TYPE c VALUE 'BUS2012',
               c_bus_rc(7) TYPE c VALUE 'BUS2105',
               c_obj_fs(9) TYPE c VALUE 'MMPUR_SES',
               c_o         TYPE c VALUE 'O'.

    DATA: ls_objhead  LIKE LINE OF tab_objhead,
          ls_ponumber TYPE zst_dados_anexo-po_number.

    ls_ponumber      = |{ data-po_number ALPHA = IN }|.
    object-objkey    = ls_ponumber.                                             "Purchase Order or Requisition

    object-objtype   = COND #( WHEN data-type_document = 'RC'
                               THEN c_bus_rc(7)

                               WHEN data-type_document = 'PC'
                               THEN c_bus_pc(7)

                               WHEN data-type_document = 'FS'
                               THEN c_obj_fs(9) ).

    objdata-objsns   = c_o.
    objdata-objla    = sy-langu.
    objdata-objdes   = data-name_file.                       "Name File
    objdata-file_ext = to_upper( data-type ).                "Extension
    objdata-objlen   = solix_length.
    objdata-objlen   = |{ objdata-objlen ALPHA = IN }|.

    ls_objhead-line  = COND #( WHEN objdata-file_ext = 'DOC'
                               THEN |&SO_FILENAME={ data-name_file }.docx|

                               WHEN objdata-file_ext = 'XLS'
                               THEN |&SO_FILENAME={ data-name_file }.xlsx|

                               WHEN objdata-file_ext = 'TXT'
                               THEN |&SO_FILENAME={ data-name_file }.txt|

                               ELSE |&SO_FILENAME={ data-name_file }.{ objdata-file_ext } | ).

    APPEND ls_objhead TO tab_objhead.

    ls_objhead-line = '&SO_FORMAT=BIN'.
    APPEND ls_objhead TO tab_objhead.

    IF data-type_document = 'FS'.

      CLEAR ls_objhead.
      ls_objhead-line = '&SO_FORMAT=BIN'.
      APPEND ls_objhead TO tab_objhead.

      CLEAR ls_objhead.

      ls_objhead-line  = COND #( WHEN objdata-file_ext = 'DOC'
                                 THEN |&SO_CONTTYPE=application/docx|

                                 WHEN objdata-file_ext = 'XLS'
                                 THEN |&SO_CONTTYPE=application/xlsx|

                                 WHEN objdata-file_ext = 'TXT'
                                 THEN |&SO_CONTTYPE=application/txt|

                                 ELSE |&SO_CONTTYPE=application/{ objdata-file_ext } | ).


      APPEND ls_objhead TO tab_objhead.

      objdata-objnam = 'MESSAGE'.
      objdata-objdes  = COND #( WHEN objdata-file_ext = 'DOC'
                                THEN |{ data-name_file } docx.docx |

                                WHEN objdata-file_ext = 'XLS'
                                THEN |{ data-name_file } xlsx.xlsx |

                                WHEN objdata-file_ext = 'TXT'
                                THEN |{ data-name_file } txt.txt |

                                ELSE |{ data-name_file } { objdata-file_ext }.{ objdata-file_ext } | ).
    ENDIF.

  ENDMETHOD.