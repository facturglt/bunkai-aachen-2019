*&---------------------------------------------------------------------*
*& Report RE3TR_SAP_BNK
*&---------------------------------------------------------------------*
*& Dieses Programm wurde automatisch erstellt !
*& ==> keine manuelle Änderung erlaubt !
*&---------------------------------------------------------------------*
*&  Generierungsdaten:
*&    Name: GLASMACHER
*&    Time: 12:59:28 Date: 11.07.2017
*&---------------------------------------------------------------------*

report RE3TR_SAP_BNK message-id em.

*$*$ start of section 1
include: RE3DAALL,
         RE3DA_SAP_BNK,
         RE3FOALL,
         RE3FO_SAP_BNK.
*$*$ end of section 1

start-of-selection.

*$*$ start of section 2

* check if upgrade is running
  call function 'UPGRUNT_CHECK_ZDM_RUNNING'
    importing
      ev_zdm_running = h_upg.
  if h_upg <> SPACE.
    message e282(em).
  endif.

  if sy-batch ne k_x and
     knz_di ne k_x   and
     p_screen eq k_x.
    call selection-screen 100.
    if sy-subrc ne 0. exit. endif.
  endif.

  if not filenam1 is initial.
    concatenate filenam1 filenam2
                filenam3 filenam4
           into filename.
  endif.
  if not errnam1 is initial.
    concatenate errnam1 errnam2
                errnam3 errnam4
           into errname.
  endif.

  temksv-firma    = 'SAP'.
  temksv-object   = 'BANK'.
  used_wmode      = '3'.
  save_repeat     = k_repeat.
  h_ref_object   = 'BANK'.
  knz_lock_enable = k__.

  h_qcp = qcp.
  cl_conv = cl_abap_conv_in_ce=>create(
               encoding = h_qcp input = h_xstring
               ignore_cerr = abap_true replacement = '#' ).
  CALL FUNCTION 'ISU_M_UNICODE_CHECK'
    EXPORTING
      x_codepage     = qcp
    IMPORTING
      y_is_uc_system = knz_unicode.
  if knz_unicode eq 'X'.
    cl_view_data   =
          cl_abap_view_offlen=>create_unicode16_view( imp ).
    cl_view_nodata =
          cl_abap_view_offlen=>create_unicode16_view(
                                                  himp_nodata ).
  else.
    cl_view_data   =
          cl_abap_view_offlen=>create_legacy_view( imp ).
    cl_view_nodata =
          cl_abap_view_offlen=>create_legacy_view(
                                                  himp_nodata ).
  endif.

  perform GET_SYSTEM_CPAGE.
  if rc ne 0.
    exit.
  endif.
  perform MSG_OPEN
    USING temksv-object.
  perform OPEN_FILE
    USING FILENAME
          'I'
          K_X.
  if rc ne 0.
    exit.
  endif.
  perform OPEN_FILE
    USING ERRNAME
          'O'
          KNZ_ERR.
  if rc ne 0.
    exit.
  endif.
  perform BATCH_MSG.
  perform INIT_ITYP.
  perform CREATE_STAT.
  perform CHECK_AUTH.
  if rc ne 0.
    exit.
  endif.
  perform CHECK_COMMIT.
  perform DEAKTIVATE_PARAMETER.
  perform HOLD_TIME
    USING 'Start:'.
*$*$ end of section 2
*$*$ start of section 3

  do.
    perform READ_DATA.
    if rc ne 0.
      exit.
    endif.

    case imp-ddtyp.

      when 'BANK'.
        perform CHECK_ITYP
          USING 'BANK'.
        if rc ne 0.
          exit.
        endif.
        perform fill_BNKA.
        move-corresponding BNKA
        to auto-BNKA.
        knz_new = space.
        if h_dttyp eq space.
          loop at ityp where ddtyp eq imp-ddtyp.
            ityp-check = k_x.
            modify ityp.
          endloop.
        else.
          append imp-ddtyp to htyp.
        endif.

      when '&ENDE'.

        perform check_objekt.
        perform CHECK_ERROR.
        if k_continue ne space.
          continue.
        endif.
        perform TEMP_MSG_OPEN.
        mac_break.

        CALL FUNCTION 'ISU_M_BANKADR_CREATE'
          IMPORTING
            Y_UPDATE               = DB_UPDATE
          CHANGING
            AUTO                   = AUTO
          EXCEPTIONS
            ALREADY_EXISTING       = 1
            INPUT_ERROR            = 2
            OTHERS                 = 3
                  .
        perform SERVICE_ERROR
          USING 'ISU_M_BANKADR_CREATE'
                sy-subrc.
        if k_continue ne space.
          continue.
        endif.

        move AUTO-BNKA-BANKL to temksv-newkey.

        CALL FUNCTION 'ISU_M_KSV_UPDATE'
          EXPORTING
            X_TEMKSV          = TEMKSV
            X_WMODE           = USED_WMODE
            X_UPDATE          = DB_UPDATE
          IMPORTING
            Y_COMMIT          = H_COMMIT
          EXCEPTIONS
            NO_DB_UPD         = 1
            NO_NEWKEY         = 2
            NO_OLDKEY         = 3
            NO_KSV_UPD        = 4
            WMODE_ERROR       = 5
            OTHERS            = 6
                  .

        perform update_error using sy-subrc.
        if k_continue ne space.
          continue.
        endif.

        perform COMMIT_WORK.


      when others.
        perform CASE_OTHERS_EVENT
          USING 'BANK'.
        if k_exit eq k_x.
          exit.
        endif.

    endcase.
  enddo.
*$*$ end of section 3
*$*$ start of section 4
*$*$ end of section 4

end-of-selection.
*$*$ start of section 5
  perform CLOSE_STAT.
  perform CLOSE_FILE
    USING filename
          'I'
          k_x.
  perform CLOSE_FILE
    USING errname
          'O'
          knz_err.
  perform HOLD_TIME
    USING 'End  :'.
  perform MSG_CLOSE
    USING knz_show.
