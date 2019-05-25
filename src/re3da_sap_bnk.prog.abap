*&---------------------------------------------------------------------*
*** INCLUDE RE3DA_SAP_BNK
*&---------------------------------------------------------------------*
*&  Dieses Include wurde automatisch erstellt !
*& ==> keine manuelle Änderung erlaubt !
*&---------------------------------------------------------------------*
*&  Generierungsdaten:
*&    Name: GLASMACHER
*&    Zeit: 12:59:28 Datum: 11.07.2017
*&---------------------------------------------------------------------*



data: itemksv like temksv.

tables: BNKA.

data: auto type ISUMI_BANK_AUTO.
data: begin of z_BNKA,
        BANKS like BNKA-BANKS,
        BANKL like BNKA-BANKL,
        BANKA like BNKA-BANKA,
        STRAS like BNKA-STRAS,
        ORT01 like BNKA-ORT01,
      end of z_BNKA.
data: v_BNKA type ref to cl_abap_view_offlen.
