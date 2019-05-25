*&---------------------------------------------------------------------*
*** INCLUDE RE3FO_SAP_BNK
*&---------------------------------------------------------------------*
*&  Dieses Include wurde automatisch erstellt !
*& ==> keine manuelle Änderung erlaubt !
*&---------------------------------------------------------------------*
*&  Generierungsdaten:
*&    Name: GLASMACHER
*&    Zeit: 12:59:28 Datum: 11.07.2017
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      form INIT_ITYP
*&---------------------------------------------------------------------*
form init_ityp.

  refresh ityp.
  clear ityp.
  move 'BANK' to ityp-ddtyp.
  append ityp.

  if knz_unicode eq 'X'.
    v_BNKA = cl_abap_view_offlen=>create_unicode16_view(
                      z_BNKA ).
  else.
    v_BNKA = cl_abap_view_offlen=>create_legacy_view(
                      z_BNKA ).
  endif.

endform.

*&---------------------------------------------------------------------*
*&      form FILL_BNKA
*&---------------------------------------------------------------------*
form fill_BNKA.

* * Füllen der Kundenstruktur
  clear z_BNKA.
  CALL METHOD cl_conv->read( EXPORTING view = v_BNKA
                             IMPORTING data = z_BNKA ).

* * Übergabestruktur initialisieren
  clear: BNKA,
         rc.

* * Füllen von Feld BNKA-BANKS
  move z_BNKA-BANKS
    to BNKA-BANKS.
  translate BNKA-BANKS to upper case.

* * Füllen von Feld BNKA-BANKL
  move z_BNKA-BANKL
    to BNKA-BANKL.
  translate BNKA-BANKL to upper case.

* * Füllen von Feld BNKA-BANKA
  move z_BNKA-BANKA
    to BNKA-BANKA.

* * Füllen von Feld BNKA-STRAS
  move z_BNKA-STRAS
    to BNKA-STRAS.

* * Füllen von Feld BNKA-ORT01
  move z_BNKA-ORT01
    to BNKA-ORT01.

* * Prüfen Inhalt Mussfeld
  check jump-knz eq space.
  if BNKA-BANKS eq space.
    mac_msg_putx 'E' '111'
                 'EM' imp-oldkey
                 'BNKA-BANKS' space
                 space space.
    mac_jump 5.
  endif.
  if BNKA-BANKL eq space.
    mac_msg_putx 'E' '111'
                 'EM' imp-oldkey
                 'BNKA-BANKL' space
                 space space.
    mac_jump 5.
  endif.
  if BNKA-BANKA eq space.
    mac_msg_putx 'E' '111'
                 'EM' imp-oldkey
                 'BNKA-BANKA' space
                 space space.
    mac_jump 5.
  endif.


endform.

*&---------------------------------------------------------------------*
*&      form CLEAR_AUTO_STRUCTURE
*&---------------------------------------------------------------------*
form clear_auto_structure.

  free auto.

endform.

