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
         message('Запрещено удалять активные условия публикации',error);
         stop;abort;exit
       }

      if getfirst JRN_TERMS_SUBSCR = tsOK then  {
       message('У условия публикации есть подписчики, удаление невозможно',error);
       stop;abort;exit
     }
  }
 if message('Удалить?',YesNo)<>cmYes  {
   abort; exit;
  }
  delete Current #table;
}
end; //TableEvent table #table
#end

Window wnJRN_TRACKING_PUBLICATION_TERMS_Edit 'Редактирование условия публикации' ;
  //---------------------------------------------
    Screen ScrJRN_TRACKING_PUBLICATION_TERMS_Edit (,,Sci18Esc);
    Show at (,,80,7);
    Table JRN_TERM;
    Fields
     statusname           : Protect, {Font={Color=getColorStatus(JRN_TERM.status)}};
     JRN_TERM.CODE        : NoProtect, #colorneed(JRN_TERM.CODE='');
     JRN_TERM.NAME        : NoProtect, #colorneed(JRN_TERM.NAME='');
     JRN_TERM.Description : NoProtect;
     TblTerm.XF$NAME  : Protect, #colorneed(JRN_TERM.wtable =0), PickButton;
     TblTerm.XF$TITLE : Skip;
     JRN_TERM.operation : skip;
    buttons
     cmValue1,[singleLine],,;
     cmValue2,[singleLine],,;
<<
 `Статус` .@@@@@@@@@@@@@@@@@@@@@@@@@@  <.   Активировать   .> <.   Редактировать  .>
`Код` .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@`Наименование`.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
`Описание`.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
`Таблица:` `наименование`.@@@@@@@@@@@@@@@@@@@@@@@@@@@ `код` .@@@@@@@@@@@@@@@@@@@@@@@@@@@
`Отслеживаем` пока не работает:
           [.] - insert`
           [.] - update`
           [.] - delete`

        При обработке в конец секции "JOIN и WHERE" будет добавлено следующее:
        " and <основная таблица>.nrec = <NREC измененной таблицы>"
>>
    end;//Screen ScrQRY_getParameter

Screen ScrScrJRN_TRACKING_PUBLICATION_subscribers_Edit_panel(,,Sci1Esc);
Show at (81,1,,1) Fixed_y;
<<
`Подписчики`
>>
end;

Browse brJRN_TERMS_SUBSCR;
  Show at (81,2,,7);
Table JRN_TERMS_SUBSCR;
Fields
  JRN_TERMS_SUBSCR.ObjType     'типа объекта'   : [3] , NoProtect, NoPickButton, #colorneed(TRIM(JRN_TERMS_SUBSCR.ObjType)='');
  JRN_TERMS_SUBSCR.ObjCode     'Код экземпляра' : [6] , NoProtect, NoPickButton, #colorneed(TRIM(JRN_TERMS_SUBSCR.ObjCode)='');
  JRN_TERMS_SUBSCR.Description 'Описание'       : [10] ,NoProtect, NoPickButton;
end;//Browse brNormPercent

text JRN_TERM.JoinWhereTerms 'Секция join и where';
        show at ( ,8,,);

end; // window

browse brJRN_TERMS;
 table JRN_TERM;
  Fields
     statusname           'Статус'       : [5]  , Protect, nopickbutton, {Font={Color=getColorStatus(JRN_TERM.status)}};
     JRN_TERM.CODE        'Код'          : [5]  , Protect, nopickbutton, #colorneed(JRN_TERM.CODE='');
     JRN_TERM.NAME        'Наименование' : [10] , Protect, nopickbutton, #colorneed(JRN_TERM.name='');
     JRN_TERM.Description 'Описание'     : [15] , Protect, nopickbutton;
     TblTerm.XF$NAME      'Таблица'      : [10] , Protect, nopickbutton, #colorneed(JRN_TERM.wtable=0);
end;

#tableeventtable(JRN_TERM)
#tableeventtable(JRN_TERMS_SUBSCR)

windowevent wnJRN_TRACKING_PUBLICATION_TERMS_Edit;
cmValue1:{
  message('cmValue1');
}
cmValue2:{
  message('cmValue2');
}

end;
