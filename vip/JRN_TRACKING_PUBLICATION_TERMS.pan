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
 `Статус` .@@@@@@@@@@@@@@@@@@@@@@@@@@  <.   Активировать   .> <.   Редактировать  .>
`Офис`.@@@
`Код` .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@`Наименование`.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
`Описание`.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
`Таблица:` `наименование`.@@@@@@@@@@@@@@@@@@@@@@@@@@@ .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 [.] - использовать кастомное поля для передачи в объект` `Наименование поля`.@@@@@@@@@@@@@@@@@@@@@@@@@

`Отслеживаем` пока не работает:
           [.] - insert`
           [.] - update`
           [.] - delete`
При обработке в конец секции "JOIN и WHERE" будет добавлено следующее:" and <основная таблица>.nrec = <NREC_TO_OBJECT>"
где: NREC_TO_OBJECT = кастомному полю, иначе NREC таблицы по которой изменение прошло
Например при изменении внешнего атрибута, надо передать МЦ, к которой он привязан, но только по определенным группам МЦ
тогда секции WHERE по таблице attrval к ТМЦ будет такая, при этом кастомным полем будет "mc.nrec"
join katmc mc on mc.nrec = attrval.crec
join groupmc grmc on grmc.nrec = katmc.cgroupmc
where atrval.wtable = 1411 and grmc.kod in ('010','011','012')
А в качестве шаблона передачи выбираем шаблон к ТМЦ
>>
    end;//Screen ScrQRY_getParameter

Screen ScrScrJRN_TRACKING_PUBLICATION_subscribers_Edit_panel(,,Sci1Esc);
Show at (81,1,,1) Fixed_y;
<<
`Подписчики`
>>
end;

Browse brJRN_TERMS_SUBSCR;
  Show at (81,2,,);
Table JRN_TERMS_SUBSCR;
Fields
  JRN_TERMS_SUBSCR.ObjType     'типа объекта'   : [3] , NoProtect, NoPickButton, #colorneed(TRIM(JRN_TERMS_SUBSCR.ObjType)='');
  JRN_TERMS_SUBSCR.ObjCode     'Код экземпляра' : [6] , NoProtect, NoPickButton, #colorneed(TRIM(JRN_TERMS_SUBSCR.ObjCode)='');
  JRN_TERMS_SUBSCR.Description 'Описание'       : [10] ,NoProtect, NoPickButton;
end;//Browse brNormPercent

text JRN_TERM.JoinWhereTerms 'Секция join и where';
        show at ( ,6,80,);

end; // window

browse brJRN_TERMS;
 table JRN_TERM;
  Fields
     statusname           'Статус'       : [5]  , Protect, nopickbutton, {Font={Color=getColorStatus(JRN_TERM.status)}};
     JRN_TERM.officeno    'Офис'         : [2]  , Protect, nopickbutton, #colorneed(JRN_TERM.officeno = 0);
     JRN_TERM.CODE        'Код'          : [5]  , Protect, nopickbutton, #colorneed(JRN_TERM.CODE='');
     JRN_TERM.NAME        'Наименование' : [10] , Protect, nopickbutton, #colorneed(JRN_TERM.name='');
     JRN_TERM.Description 'Описание'     : [15] , Protect, nopickbutton;
     TblTerm.XF$NAME      'Таблица'      : [10] , Protect, nopickbutton, #colorneed(JRN_TERM.wtable=0);
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
     message('Ошибка активации' +
      + ''#13'' + _err,error);
     PutFileToClient(__log,false);
   }
  else {
   message('Условие корректно');
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
