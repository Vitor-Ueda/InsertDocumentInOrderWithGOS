  METHOD treat_exception.

    CALL FUNCTION 'RS_EXCEPTION_TO_BAPIRET2'
      EXPORTING
        i_r_exception = exception
      CHANGING
        c_t_bapiret2  = bapirettab.

  ENDMETHOD.