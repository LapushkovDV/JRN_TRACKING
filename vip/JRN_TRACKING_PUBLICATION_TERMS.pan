#declare colorneed (FldCondition)
{Font={BackColor=if(#FldCondition,ColorNeed,0)}}
#end
#declare tableeventtable (table)
TableEvent table #table;
cmSetDefault: {
    putcommand(cmDefault);
}
cmInsertRecord: {
  Insert Current #table;
}
cmUpdateRecord: {
  Update Current #table;
}
cmDeleteRecord: {
  if curtable = tnJRN_TERM {
        if JRN_TERM.status = 1 then  {
         message('����饭� 㤠���� ��⨢�� �᫮��� �㡫���樨',error);
         stop;abort;exit
       }

      if getfirst JRN_TERMS_SUBSCR = tsOK then  {
       message('� �᫮��� �㡫���樨 ���� ������稪�, 㤠����� ����������',error);
       stop;abort;exit
     }
  }
 if message('�������?',YesNo)<>cmYes  {
   abort; exit;
  }
  delete Current #table;
}
end; //TableEvent table #table
#end

Window wnJRN_TRACKING_PUBLICATION_TERMS_Edit '������஢���� �᫮��� �㡫���樨' ;
  //---------------------------------------------
    Screen ScrJRN_TRACKING_PUBLICATION_TERMS_Edit (,,Sci18Esc);
    Show at (,,80,5);
    Table JRN_TERM;
    Fields
     statusname           : Protect, {Font={Color=getColorStatus(JRN_TERM.status)}};
     JRN_TERM.officeno    : NoProtect, #colorneed(JRN_TERM.officeno = 0);
     JRN_TERM.CODE        : NoProtect, #colorneed(JRN_TERM.CODE='');
     JRN_TERM.NAME        : NoProtect, #colorneed(JRN_TERM.NAME='');
     JRN_TERM.Description : NoProtect;
     TblTerm.XF$NAME  : Protect, #colorneed(JRN_TERM.wtable =0), PickButton;
     TblTerm.XF$TITLE : Skip;
     JRN_TERM.useCustomField : NoProtect;
     JRN_TERM.customfield    : NoProtect;
     JRN_TERM.operation : skip;
    buttons
     cmValue1,[singleLine],,;
     cmValue2,[singleLine],,;
<<
 `�����` .@@@@@@@@@@@@@@@@@@@@@@@@@@  <.   ��⨢�஢���   .> <.   ������஢���  .>
`���`.@@@
`���` .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@`������������`.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
`���ᠭ��`.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
`������:` `������������`.@@@@@@@@@@@@@@@@@@@@@@@@@@@ .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 [.] - �ᯮ�짮���� ���⮬��� ���� ��� ��।�� � ��ꥪ�` `������������ ����`.@@@@@@@@@@@@@@@@@@@@@@@@@

`��᫥������` ���� �� ࠡ�⠥�:
           [.] - insert`
           [.] - update`
           [.] - delete`
�� ��ࠡ�⪥ � ����� ᥪ樨 "JOIN � WHERE" �㤥� ��������� ᫥���饥:" and <�᭮���� ⠡���>.nrec = <NREC_TO_OBJECT>"
���: NREC_TO_OBJECT = ���⮬���� ����, ���� NREC ⠡���� �� ���ன ��������� ��諮
���ਬ�� �� ��������� ���譥�� ��ਡ��, ���� ��।��� ��, � ���ன �� �ਢ易�, �� ⮫쪮 �� ��।������ ��㯯�� ��
⮣�� ᥪ樨 WHERE �� ⠡��� attrval � ��� �㤥� ⠪��, �� �⮬ ���⮬�� ����� �㤥� "mc.nrec"
join katmc mc on mc.nrec = attrval.crec
join groupmc grmc on grmc.nrec = katmc.cgroupmc
where atrval.wtable = 1411 and grmc.kod in ('010','011','012')
� � ����⢥ 蠡���� ��।�� �롨ࠥ� 蠡��� � ���
>>
    end;//Screen ScrQRY_getParameter

Screen ScrScrJRN_TRACKING_PUBLICATION_subscribers_Edit_panel(,,Sci1Esc);
Show at (81,1,,1) Fixed_y;
<<
`������稪�`
>>
end;

Browse brJRN_TERMS_SUBSCR;
  Show at (81,2,,);
Table JRN_TERMS_SUBSCR;
Fields
  JRN_TERMS_SUBSCR.ObjType     '⨯� ��ꥪ�'   : [3] , NoProtect, NoPickButton, #colorneed(TRIM(JRN_TERMS_SUBSCR.ObjType)='');
  JRN_TERMS_SUBSCR.ObjCode     '��� �������' : [6] , NoProtect, NoPickButton, #colorneed(TRIM(JRN_TERMS_SUBSCR.ObjCode)='');
  JRN_TERMS_SUBSCR.Description '���ᠭ��'       : [10] ,NoProtect, NoPickButton;
end;//Browse brNormPercent

text JRN_TERM.JoinWhereTerms '����� join � where';
        show at ( ,6,80,);

end; // window

browse brJRN_TERMS;
 table JRN_TERM;
  Fields
     statusname           '�����'       : [5]  , Protect, nopickbutton, {Font={Color=getColorStatus(JRN_TERM.status)}};
     JRN_TERM.officeno    '���'         : [2]  , Protect, nopickbutton, #colorneed(JRN_TERM.officeno = 0);
     JRN_TERM.CODE        '���'          : [5]  , Protect, nopickbutton, #colorneed(JRN_TERM.CODE='');
     JRN_TERM.NAME        '������������' : [10] , Protect, nopickbutton, #colorneed(JRN_TERM.name='');
     JRN_TERM.Description '���ᠭ��'     : [15] , Protect, nopickbutton;
     TblTerm.XF$NAME      '������'      : [10] , Protect, nopickbutton, #colorneed(JRN_TERM.wtable=0);
end;

#tableeventtable(JRN_TERM)
#tableeventtable(JRN_TERMS_SUBSCR)

windowevent wnJRN_TRACKING_PUBLICATION_TERMS_Edit;
cminit : {
  setenabledcommand;
}
cmValue1:{
  updatetable;
  var iJRN_TRACKING_BASE : JRN_TRACKING_BASE new;
  var _err : string = '';
  iJRN_TRACKING_BASE.enableLog;

  if not iJRN_TRACKING_BASE.CheckQueryTerm(JRN_TERM.nrec, 0h, 0h, _err) {
  var __log : string = iJRN_TRACKING_BASE.GetLogFile;
     message('�訡�� ��⨢�樨' +
      + ''#13'' + _err,error);
     PutFileToClient(__log,false);
   }
  else {
   message('�᫮��� ���४⭮');
   update current JRN_TERM set JRN_TERM.status := 1;
  }
  iJRN_TRACKING_BASE.disableLog;
  setenabledcommand;
  rereadrecord;
}
cmValue2:{

  update current JRN_TERM set JRN_TERM.status := 0;
 setenabledcommand;
   rereadrecord;
}

end;
