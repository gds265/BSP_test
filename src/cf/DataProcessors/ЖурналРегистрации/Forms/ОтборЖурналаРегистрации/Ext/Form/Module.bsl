﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьВажностьИСтатус();
	ЗаполнитьПараметрыОтбора();
	
	СобытияПоУмолчанию = Параметры.СобытияПоУмолчанию;
	Если СобытияПоУмолчанию.Количество() <> События.Количество() Тогда
		СобытияОтображаемые = События.Скопировать();
	КонецЕсли;
	
	ВидимостьРазделения = Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	ТолькоСтандартныеРазделители = ЖурналРегистрации.ТолькоСтандартныеРазделители();
	Элементы.РазделениеДанныхСеанса.Видимость = ВидимостьРазделения И Не ТолькоСтандартныеРазделители;
	Элементы.ОбластиДанных.Видимость = ВидимостьРазделения И ТолькоСтандартныеРазделители;
	Если Элементы.ОбластиДанных.Видимость Тогда
		Для Каждого ЭлементСписка Из РазделениеДанныхСеанса Цикл
			Если СтрНачинаетсяС(ЭлементСписка.Значение, "ОбластьДанныхОсновныеДанные") Тогда
				ЧастиСтроки = СтрРазделить(ЭлементСписка.Значение, "=");
				ОбластиДанных = ЖурналРегистрации.СписокЗначенийРазделителейИзСтроки(ЧастиСтроки[1]);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыборЗначенийЭлементовОтбораЖурналаРегистрации"
	   И Источник.УникальныйИдентификатор = УникальныйИдентификатор Тогда
		Если РедакторСоставаСвойстваИмяЭлемента = Элементы.Пользователи.Имя Тогда
			СписокПользователей = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.События.Имя Тогда
			События = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.Компьютеры.Имя Тогда
			Компьютеры = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.Приложения.Имя Тогда
			Приложения = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.Метаданные.Имя Тогда
			Метаданные = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.РабочиеСерверы.Имя Тогда
			РабочиеСерверы = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.ОсновныеIPПорты.Имя Тогда
			ОсновныеIPПорты = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.ВспомогательныеIPПорты.Имя Тогда
			ВспомогательныеIPПорты = Параметр;
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.ОбластиДанных.Имя Тогда
			ОбластиДанных = Параметр;
			РазделениеДанныхСеанса = СписокВсехРазделителей(Параметр);
		ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.РазделениеДанныхСеанса.Имя Тогда
			РазделениеДанныхСеанса = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	СобытияОтображаемые.Очистить();
	
	Если События.Количество() = 0 Тогда
		События = СобытияПоУмолчанию;
		Возврат;
	КонецЕсли;
	
	Если СобытияПоУмолчанию.Количество() <> События.Количество() Тогда
		СобытияОтображаемые = События.Скопировать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СобытияОтображаемые.Очистить();

	Если События.Количество() = 0 Тогда
		События = СобытияПоУмолчанию;
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(СобытияПоУмолчанию, События) Тогда
		СобытияОтображаемые = События.Скопировать();
	КонецЕсли;
	
	Элементы.Данные.Видимость = НЕ ДанныеНесколькоЗначений;
	Элементы.ДанныеСписок.Видимость = ДанныеНесколькоЗначений;
	
	ОбновитьЗаголовкиГруппФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсполнениеВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Перем РедактируемыйСписок, ОтбираемыеПараметры;
	
	ОтключитьСтандартнуюОбработку = Истина;
	РедакторСоставаСвойстваИмяЭлемента = Элемент.Имя;
	
	Если РедакторСоставаСвойстваИмяЭлемента = Элементы.Пользователи.Имя Тогда
		РедактируемыйСписок = СписокПользователей;
		ОтбираемыеПараметры = "Пользователь";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.События.Имя Тогда
		РедактируемыйСписок = События;
		ОтбираемыеПараметры = "Событие";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.Компьютеры.Имя Тогда
		РедактируемыйСписок = Компьютеры;
		ОтбираемыеПараметры = "Компьютер";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.Приложения.Имя Тогда
		РедактируемыйСписок = Приложения;
		ОтбираемыеПараметры = "ИмяПриложения";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.Метаданные.Имя Тогда
		РедактируемыйСписок = Метаданные;
		ОтбираемыеПараметры = "Метаданные";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.РабочиеСерверы.Имя Тогда
		РедактируемыйСписок = РабочиеСерверы;
		ОтбираемыеПараметры = "РабочийСервер";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.ОсновныеIPПорты.Имя Тогда
		РедактируемыйСписок = ОсновныеIPПорты;
		ОтбираемыеПараметры = ОсновнойIPПорт();
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.ВспомогательныеIPПорты.Имя Тогда
		РедактируемыйСписок = ВспомогательныеIPПорты;
		ОтбираемыеПараметры = "ВспомогательныйIPПорт";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.ОбластиДанных.Имя Тогда
		РедактируемыйСписок = ОбластиДанных;
		ОтбираемыеПараметры = "РазделениеДанныхСеансаЗначения" + "." + "ОбластьДанныхОсновныеДанные";
	ИначеЕсли РедакторСоставаСвойстваИмяЭлемента = Элементы.РазделениеДанныхСеанса.Имя Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УстановленныйОтбор", РазделениеДанныхСеанса);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.РазделениеДанныхСеанса", ПараметрыФормы, ЭтотОбъект);
		Возврат;
	Иначе
		ОтключитьСтандартнуюОбработку = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ОтключитьСтандартнуюОбработку Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("РедактируемыйСписок", РедактируемыйСписок);
	ПараметрыФормы.Вставить("ОтбираемыеПараметры", ОтбираемыеПараметры);
	
	// Открытие редактора свойства.
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.РедакторСоставаСвойства",
	             ПараметрыФормы,
	             ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластиДанныхОчистка(Элемент, СтандартнаяОбработка)
	
	РазделениеДанныхСеанса.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура СобытияОчистка(Элемент, СтандартнаяОбработка)
	
	События = СобытияПоУмолчанию;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОтбораПриИзменении(Элемент)
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ИнтервалОтбораПриИзмененииЗавершение", ЭтотОбъект);
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = ИнтервалОтбора;
	Диалог.Показать(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОтбораПриИзмененииЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Период = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтервалОтбора = Период;
	ИнтервалОтбораДатаНачала    = ИнтервалОтбора.ДатаНачала;
	ИнтервалОтбораДатаОкончания = ИнтервалОтбора.ДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОтбораДатаПриИзменении(Элемент)
	
	ИнтервалОтбора.Вариант       = ВариантСтандартногоПериода.ПроизвольныйПериод;
	ИнтервалОтбора.ДатаНачала    = ИнтервалОтбораДатаНачала;
	ИнтервалОтбора.ДатаОкончания = ИнтервалОтбораДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура НесколькоЗначенийПриИзменении(Элемент)
	
	ИмяДанных = Элементы.Данные.Имя;
	ИмяСпискаДанных = Элементы.ДанныеСписок.Имя;
	ОдноЗначение = Не ДанныеНесколькоЗначений;
	
	Элементы[ИмяДанных].Видимость = ОдноЗначение;
	Элементы[ИмяСпискаДанных].Видимость = Не ОдноЗначение;
	ТекущиеДанные = ЭтотОбъект[ИмяДанных];
	ТекущийСписок = ЭтотОбъект[ИмяСпискаДанных];
	
	Если ОдноЗначение Тогда
		ЭтотОбъект[ИмяДанных] = ?(ТекущийСписок.Количество() = 0,
			Неопределено, ТекущийСписок[0].Значение);
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные)
	      Или ТекущийСписок.Количество() > 0 Тогда
		
		Если ТекущийСписок.Количество() = 0 Тогда
			ТекущийСписок.Добавить();
		КонецЕсли;
		ТекущийСписок[0].Значение = ТекущиеДанные;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	ОбновитьПолеКомментарий(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ОбновитьПолеКомментарий(ЭтотОбъект, Текст);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтборИЗакрытьФорму(Команда)
	
	ОповеститьОВыборе(
		Новый Структура("Событие, Отбор", 
			"УстановленОтборЖурналаРегистрации", 
			ПолучитьОтборЖурналаРегистрации()));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажкиВажности(Команда)
	Для Каждого ЭлементСписка Из Важность Цикл
		ЭлементСписка.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажкиВажности(Команда)
	Для Каждого ЭлементСписка Из Важность Цикл
		ЭлементСписка.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусыТранзакции(Команда)
	Для Каждого ЭлементСписка Из СтатусТранзакции Цикл
		ЭлементСписка.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьСтатусыТранзакции(Команда)
	Для Каждого ЭлементСписка Из СтатусТранзакции Цикл
		ЭлементСписка.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиВФайл(Команда)

	АдресВременногоХранилища =  СохранитьНастройкиВоВременноеХранилище();
	
	ПараметрыСохраненияФайла = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();                            
	ПараметрыСохраненияФайла.Диалог.Фильтр = НСтр("ru = 'Настройки журнала регистрации'") + "(*.xml)|*.xml";
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, АдресВременногоХранилища, "Settings.xml", ПараметрыСохраненияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройкиИзФайла(Команда)
	
	ПараметрыЗагрузкиФайла = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();   
	ПараметрыЗагрузкиФайла.Диалог.Заголовок = НСтр("ru = 'Выберите файл с настройками отбора журнала регистрации'");
	ПараметрыЗагрузкиФайла.Диалог.Фильтр = НСтр("ru = 'Файл xml'") + "(*.xml)|*.xml";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьНастройкиИзФайлаЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОписаниеОповещения, ПараметрыЗагрузкиФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВажностьИСтатус()
	// Заполнение ЭУ Важность
	Важность.Добавить("Ошибка",         Строка(УровеньЖурналаРегистрации.Ошибка));
	Важность.Добавить("Предупреждение", Строка(УровеньЖурналаРегистрации.Предупреждение));
	Важность.Добавить("Информация",     Строка(УровеньЖурналаРегистрации.Информация));
	Важность.Добавить("Примечание",     Строка(УровеньЖурналаРегистрации.Примечание));
	
	// Заполнение ЭУ СтатусТранзакции
	СтатусТранзакции.Добавить("НетТранзакции", Строка(СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции));
	СтатусТранзакции.Добавить("Зафиксирована", Строка(СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована));
	СтатусТранзакции.Добавить("НеЗавершена",   Строка(СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена));
	СтатусТранзакции.Добавить("Отменена",      Строка(СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыОтбора()
	
	СписокПараметровОтбора = Параметры.Отбор;
	ЕстьОтборПоУровню  = Ложь;
	ЕстьОтборПоСтатусу = Ложь;
	
	Для Каждого ПараметрОтбора Из СписокПараметровОтбора Цикл
		ИмяПараметра = ПараметрОтбора.Представление;
		Значение     = ПараметрОтбора.Значение;
		
		Если ВРег(ИмяПараметра) = ВРег("ДатаНачала") Тогда
			// ДатаНачала/StartDate
			ИнтервалОтбора.ДатаНачала = Значение;
			ИнтервалОтбораДатаНачала  = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("ДатаОкончания") Тогда
			// ДатаОкончания/EndDate
			ИнтервалОтбора.ДатаОкончания = Значение;
			ИнтервалОтбораДатаОкончания  = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Пользователь") Тогда
			// Пользователь/User
			СписокПользователей = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Событие") Тогда
			// Событие/Event
			События = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Компьютер") Тогда
			// Компьютер/Computer
			Компьютеры = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("ИмяПриложения") Тогда
			// ИмяПриложения/ApplicationName
			Приложения = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Комментарий") Тогда
			// Комментарий/Comment
			Комментарий = Значение;
			ОбновитьПолеКомментарий(ЭтотОбъект);
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Метаданные") Тогда
			// Метаданные/Metadata
			Метаданные = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Данные") Тогда
			// Данные/Data 
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				ДанныеНесколькоЗначений = Истина;
				Элементы.Данные.Видимость = Ложь;
				Элементы.ДанныеСписок.Видимость = Истина;
				ДанныеСписок = Значение;
			Иначе
				Данные = Значение;
			КонецЕсли;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("ПредставлениеДанных") Тогда
			// ПредставлениеДанных/DataPresentation
			ПредставлениеДанных = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Транзакция") Тогда
			// Транзакция/TransactionID
			Транзакция = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("РабочийСервер") Тогда
			// РабочийСервер/ServerName
			РабочиеСерверы = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Сеанс") Тогда
			// Сеанс/Seance
			Сеансы = Значение;
			СтрСеансы = "";
			Для Каждого НомерСеанса Из Сеансы Цикл
				СтрСеансы = СтрСеансы + ?(СтрСеансы = "", "", "; ") + НомерСеанса;
			КонецЦикла;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег(ОсновнойIPПорт()) Тогда
			// ОсновнойIPПорт/Port
			ОсновныеIPПорты = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("ВспомогательныйIPПорт") Тогда
			// ВспомогательныйIPПорт/SyncPort
			ВспомогательныеIPПорты = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Уровень") Тогда
			// Уровень/Level
			ЕстьОтборПоУровню = Истина;
			Для Каждого ЭлементСпискаЗначений Из Важность Цикл
				Если Значение.НайтиПоЗначению(ЭлементСпискаЗначений.Значение) <> Неопределено Тогда
					ЭлементСпискаЗначений.Пометка = Истина;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("СтатусТранзакции") Тогда
			// СтатусТранзакции/TransactionStatus
			ЕстьОтборПоСтатусу = Истина;
			Для Каждого ЭлементСпискаЗначений Из СтатусТранзакции Цикл
				Если Значение.НайтиПоЗначению(ЭлементСпискаЗначений.Значение) <> Неопределено Тогда
					ЭлементСпискаЗначений.Пометка = Истина;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("РазделениеДанныхСеанса") Тогда
			
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				РазделениеДанныхСеанса = Значение.Скопировать();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЕстьОтборПоУровню Тогда
		Для Каждого ЭлементСпискаЗначений Из Важность Цикл
			ЭлементСпискаЗначений.Пометка = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЕстьОтборПоСтатусу Тогда
		Для Каждого ЭлементСпискаЗначений Из СтатусТранзакции Цикл
			ЭлементСпискаЗначений.Пометка = Истина;
		КонецЦикла;
	ИначеЕсли ЕстьОтборПоСтатусу Или ЗначениеЗаполнено(Транзакция) Тогда
		Элементы.ГруппаТранзакции.Заголовок = Элементы.ГруппаТранзакции.Заголовок + " *";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РабочиеСерверы)
		Или ЗначениеЗаполнено(ОсновныеIPПорты)
		Или ЗначениеЗаполнено(ВспомогательныеIPПорты) Тогда
		Элементы.ГруппаПрочее.Заголовок = Элементы.ГруппаПрочее.Заголовок + " *";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьОтборЖурналаРегистрации()
	
	Сеансы.Очистить();
	Стр = СтрСеансы;
	Стр = СтрЗаменить(Стр, ";", " ");
	Стр = СтрЗаменить(Стр, ",", " ");
	Стр = СокрЛП(Стр);
	ТЧ = Новый ОписаниеТипов("Число");
	
	Пока Не ПустаяСтрока(Стр) Цикл
		Поз = СтрНайти(Стр, " ");
		
		Если Поз = 0 Тогда
			Значение = ТЧ.ПривестиЗначение(Стр);
			Стр = "";
		Иначе
			Значение = ТЧ.ПривестиЗначение(Лев(Стр, Поз-1));
			Стр = СокрЛП(Сред(Стр, Поз+1));
		КонецЕсли;
		
		Если Значение <> 0 Тогда
			Сеансы.Добавить(Значение);
		КонецЕсли;
	КонецЦикла;
	
	Отбор = Новый СписокЗначений;
	
	// Дата начала, окончания
	Если ИнтервалОтбораДатаНачала <> '00010101000000' Тогда 
		Отбор.Добавить(ИнтервалОтбораДатаНачала, "ДатаНачала");
	КонецЕсли;
	Если ИнтервалОтбораДатаОкончания <> '00010101000000' Тогда
		Отбор.Добавить(ИнтервалОтбораДатаОкончания, "ДатаОкончания");
	КонецЕсли;
	
	// Пользователь/User
	Если СписокПользователей.Количество() > 0 Тогда 
		Отбор.Добавить(СписокПользователей, "Пользователь");
	КонецЕсли;
	
	// Событие/Event
	Если События.Количество() > 0 Тогда 
		Отбор.Добавить(События, "Событие");
	КонецЕсли;
	
	// Компьютер/Computer
	Если Компьютеры.Количество() > 0 Тогда 
		Отбор.Добавить(Компьютеры, "Компьютер");
	КонецЕсли;
	
	// ИмяПриложения/ApplicationName
	Если Приложения.Количество() > 0 Тогда 
		Отбор.Добавить(Приложения, "ИмяПриложения");
	КонецЕсли;
	
	// Комментарий/Comment
	Если Не ПустаяСтрока(Комментарий) Тогда 
		Отбор.Добавить(Комментарий, "Комментарий");
	КонецЕсли;
	
	// Метаданные/Metadata
	Если Метаданные.Количество() > 0 Тогда 
		Отбор.Добавить(Метаданные, "Метаданные");
	КонецЕсли;
	
	// Данные/Data 
	ЗначениеОтбора = ?(ДанныеНесколькоЗначений, ДанныеСписок, Данные);
	Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
		Отбор.Добавить(ЗначениеОтбора, "Данные");
	КонецЕсли;
	
	// ПредставлениеДанных/DataPresentation
	Если Не ПустаяСтрока(ПредставлениеДанных) Тогда 
		Отбор.Добавить(ПредставлениеДанных, "ПредставлениеДанных");
	КонецЕсли;
	
	// Транзакция/TransactionID
	Если Не ПустаяСтрока(Транзакция) Тогда 
		Отбор.Добавить(Транзакция, "Транзакция");
	КонецЕсли;
	
	// РабочийСервер/ServerName
	Если РабочиеСерверы.Количество() > 0 Тогда 
		Отбор.Добавить(РабочиеСерверы, "РабочийСервер");
	КонецЕсли;
	
	// Сеанс/Seance
	Если Сеансы.Количество() > 0 Тогда 
		Отбор.Добавить(Сеансы, "Сеанс");
	КонецЕсли;
	
	// ОсновнойIPПорт/Port
	Если ОсновныеIPПорты.Количество() > 0 Тогда 
		Отбор.Добавить(ОсновныеIPПорты, "ОсновнойIPПорт");
	КонецЕсли;
	
	// ВспомогательныйIPПорт/SyncPort
	Если ВспомогательныеIPПорты.Количество() > 0 Тогда 
		Отбор.Добавить(ВспомогательныеIPПорты, "ВспомогательныйIPПорт");
	КонецЕсли;
	
	// РазделениеДанныхСеанса
	Если РазделениеДанныхСеанса.Количество() > 0 Тогда 
		Отбор.Добавить(РазделениеДанныхСеанса, "РазделениеДанныхСеанса");
	КонецЕсли;
	
	// Уровень/Level
	СписокУровней = Новый СписокЗначений;
	Для Каждого ЭлементСпискаЗначений Из Важность Цикл
		Если ЭлементСпискаЗначений.Пометка Тогда 
			СписокУровней.Добавить(ЭлементСпискаЗначений.Значение, ЭлементСпискаЗначений.Представление);
		КонецЕсли;
	КонецЦикла;
	Если СписокУровней.Количество() > 0 И СписокУровней.Количество() <> Важность.Количество() Тогда
		Отбор.Добавить(СписокУровней, "Уровень");
	КонецЕсли;
	
	// СтатусТранзакции/TransactionStatus
	СписокСтатусов = Новый СписокЗначений;
	Для Каждого ЭлементСпискаЗначений Из СтатусТранзакции Цикл
		Если ЭлементСпискаЗначений.Пометка Тогда 
			СписокСтатусов.Добавить(ЭлементСпискаЗначений.Значение, ЭлементСпискаЗначений.Представление);
		КонецЕсли;
	КонецЦикла;
	Если СписокСтатусов.Количество() > 0 И СписокСтатусов.Количество() <> СтатусТранзакции.Количество() Тогда
		Отбор.Добавить(СписокСтатусов, "СтатусТранзакции");
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеКомментарий(Форма, Текст = Неопределено)
	
	Если Текст = Неопределено Тогда
		Текст = Форма.Комментарий;
	КонецЕсли;
	
	Строки = СтрРазделить(Текст, Символы.ПС);
	Если Строки.Количество() > 1 Тогда
		НоваяВысота = 2;
	Иначе
		НоваяВысота = 1;
	КонецЕсли;
	
	Если Форма.Элементы.Комментарий.Высота <> НоваяВысота Тогда
		Форма.Комментарий = Текст;
		Форма.Элементы.Комментарий.Высота = НоваяВысота;
	КонецЕсли;
	
	МаксимальнаяДлина = 1;
	Для Каждого Строка Из Строки Цикл
		Если СтрДлина(Строка) > МаксимальнаяДлина Тогда
			МаксимальнаяДлина = СтрДлина(Строка);
		КонецЕсли;
	КонецЦикла;
	
	Если МаксимальнаяДлина > 70 Тогда
		НовоеРастягивание = Истина;
	Иначе
		НовоеРастягивание = Ложь;
	КонецЕсли;
	
	Если Форма.Элементы.Комментарий.РастягиватьПоГоризонтали <> НовоеРастягивание Тогда
		Форма.Комментарий = Текст;
		Форма.Элементы.Комментарий.РастягиватьПоГоризонтали = НовоеРастягивание;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокВсехРазделителей(Параметр)
	
	Представления = Новый Массив;
	Для Каждого ЭлементСписка Из Параметр Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Представление) Тогда
			Представления.Добавить(ЭлементСписка.Представление);
		Иначе
			Представления.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ПредставлениеЗначений = СтрСоединить(Представления, ", ");
	ЗначенияСтрокой = СтрСоединить(Параметр.ВыгрузитьЗначения(), ",");
	
	Список = Новый СписокЗначений;
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.НеИспользовать Тогда
			Продолжить;
		КонецЕсли;
		ПредставлениеРазделителя = ОбщийРеквизит.Представление() + " = " + ПредставлениеЗначений;
		ЗначениеРазделителя = ОбщийРеквизит.Имя + "=" + ЗначенияСтрокой;
		Список.Добавить(ЗначениеРазделителя, ПредставлениеРазделителя);
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции

&НаСервере
Процедура ОбновитьЗаголовкиГруппФормы()
	
	КоличествоОтмеченныхСтатусов = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(СтатусТранзакции).Количество();
	Если КоличествоОтмеченныхСтатусов <> СтатусТранзакции.Количество() 
		Или ЗначениеЗаполнено(Транзакция) Тогда
		Элементы.ГруппаТранзакции.Заголовок = Элементы.ГруппаТранзакции.Заголовок + " *";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РабочиеСерверы)
		Или ЗначениеЗаполнено(ОсновныеIPПорты)
		Или ЗначениеЗаполнено(ВспомогательныеIPПорты) Тогда
		Элементы.ГруппаПрочее.Заголовок = Элементы.ГруппаПрочее.Заголовок + " *";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиВоВременноеХранилище() 
			
	СохраняемыеНастройки = СохраняемыеНастройки();
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Filters");

	ЗаписьXML.ЗаписатьНачалоЭлемента("MainFilters");
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СохраняемыеНастройки, НазначениеТипаXML.Явное);

	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Если ДанныеНесколькоЗначений Тогда		
		Для Каждого ОтбираемыеДанные Из ДанныеСписок Цикл
			ЗаписьXML.ЗаписатьНачалоЭлемента("DataFilters");
			СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ОтбираемыеДанные.Значение, НазначениеТипаXML.Явное);
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЦикла;		
	ИначеЕсли ЗначениеЗаполнено(Данные) Тогда
   		ЗаписьXML.ЗаписатьНачалоЭлемента("DataFilters");	
		СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Данные, НазначениеТипаXML.Явное);		
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЕсли;
     	
	ЗаписьXML.ЗаписатьКонецЭлемента();

	СтрокаXML = ЗаписьXML.Закрыть();
	
	ДвоичныеДанные = ПолучитьДвоичныеДанныеИзСтроки(СтрокаXML);
    АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	
	Возврат АдресВременногоХранилищаФайла;
	
КонецФункции

&НаСервере
Функция СохраняемыеНастройки()
	
	СохраняемыеНастройки = Новый СписокЗначений();
	СохраняемыеНастройки.Добавить(Важность, "Level");
	Если ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(СобытияПоУмолчанию, События) Тогда
		СохраняемыеНастройки.Добавить(Новый СписокЗначений(), "Event");
	Иначе
		СохраняемыеНастройки.Добавить(События, "Event");
	КонецЕсли;
	СохраняемыеНастройки.Добавить(Метаданные, "Metadata");
	СохраняемыеНастройки.Добавить(ИнтервалОтбораДатаНачала, "StartDate");
	СохраняемыеНастройки.Добавить(ИнтервалОтбораДатаОкончания, "EndDate");
	СохраняемыеНастройки.Добавить(СписокПользователей, "User");
	СохраняемыеНастройки.Добавить(Приложения, "ApplicationName");
	СохраняемыеНастройки.Добавить(Компьютеры, "Computer");
	СохраняемыеНастройки.Добавить(СтрСеансы, "Sessions");
	СохраняемыеНастройки.Добавить(ПредставлениеДанных, "DataPresentation");
	СохраняемыеНастройки.Добавить(СтатусТранзакции, "TransactionStatus");
	СохраняемыеНастройки.Добавить(РабочиеСерверы, "ServerName");
	СохраняемыеНастройки.Добавить(РазделениеДанныхСеанса, "SessionDataSeparation");
	СохраняемыеНастройки.Добавить(Транзакция, "TransactionID");
	СохраняемыеНастройки.Добавить(Комментарий, "Comment");   
	СохраняемыеНастройки.Добавить(ОсновныеIPПорты, "Port");
	СохраняемыеНастройки.Добавить(ВспомогательныеIPПорты, "SyncPort");
	СохраняемыеНастройки.Добавить(ОбластиДанных, "DataArea");
		
	Возврат СохраняемыеНастройки;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьНастройкиИзФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ЗагрузитьНастройкиИзФайлаНаСервере(Результат.Хранение);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Настройки отбора'"),, НСтр("ru = 'Настройки отбора загружены'"));
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиИзФайлаНаСервере(АдресВоВременномХранилище)
	
	СписокПараметровОтбораИзФайла = НастройкиИзФайла(АдресВоВременномХранилище);
	
	ПрименитьНастройкиИзФайла(СписокПараметровОтбораИзФайла);
	
	СобытияОтображаемые.Очистить();
	Если События.Количество() = 0 Тогда
		События = СобытияПоУмолчанию;
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(СобытияПоУмолчанию, События) Тогда
		СобытияОтображаемые = События.Скопировать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НастройкиИзФайла(АдресВоВременномХранилище)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);

	СтрокаXML = ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанные);	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	МассивДанных = Новый Массив;
	НастройкиОтбора = Новый СписокЗначений;
	
	Пока ЧтениеXML.Прочитать() Цикл	
		 
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			Если ЧтениеXML.Имя = "MainFilters" Тогда
				ЧтениеXML.Прочитать();
				НастройкиОтбора = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
			ИначеЕсли ЧтениеXML.Имя = "DataFilters" Тогда
				ЧтениеXML.Прочитать(); 			
				ТипXML = СериализаторXDTO.ПолучитьXMLТип(ЧтениеXML);
				Если ТипXML = XMLТип(Тип("Строка"))
					Или ТипXML = XMLТип(Тип("Дата"))
					Или ТипXML = XMLТип(Тип("Число"))
					Или ТипXML = XMLТип(Тип("Булево")) Тогда
					МассивДанных.Добавить(СериализаторXDTO.ПрочитатьXML(ЧтениеXML));
				Иначе
					Значение = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
					Если ЗначениеЗаполнено(Значение) 
						И ТипЗнч(Значение) <> Тип("Строка")
						И ОбщегоНазначения.СсылкаСуществует(Значение) Тогда
						МассивДанных.Добавить(Значение);	
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	НастройкиОтбора.Добавить(МассивДанных, "Data");
	
	ЧтениеXML.Закрыть();
	
	Возврат НастройкиОтбора;	
	
КонецФункции

&НаСервере
Процедура ПрименитьНастройкиИзФайла(СписокПараметровОтбора)
		
	ДоступныеОтборы = ДоступныеОтборыЖурналаРегистрации();
	
	Для Каждого ПараметрОтбора Из СписокПараметровОтбора Цикл
		
		ИмяПараметра = ПараметрОтбора.Представление;
		Значение     = ПараметрОтбора.Значение;
		
		Если ВРег(ИмяПараметра) = ВРег("StartDate") Тогда
			// ДатаНачала/StartDate
			ИнтервалОтбора.ДатаНачала = Значение;
			ИнтервалОтбораДатаНачала  = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("EndDate") Тогда
			// ДатаОкончания/EndDate
			ИнтервалОтбора.ДатаОкончания = Значение;
			ИнтервалОтбораДатаОкончания  = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("User") Тогда
			// Пользователь/User
			СписокПользователей = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "Пользователь");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Event") Тогда
			// Событие/Event
			События = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "Событие");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Computer") Тогда
			// Компьютер/Computer
			Компьютеры = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "Компьютер");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("ApplicationName") Тогда
			// ИмяПриложения/ApplicationName
			Приложения = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "ИмяПриложения");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Comment") Тогда
			// Комментарий/Comment
			Комментарий = Значение;
		 	
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Metadata") Тогда
			// Метаданные/Metadata
			Метаданные = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "Метаданные");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Data") Тогда
			// Данные/Data
			Если ЗначениеЗаполнено(Значение) И Значение.Количество() > 1 Тогда 
				ДанныеНесколькоЗначений = Истина;
				ДанныеСписок.ЗагрузитьЗначения(Значение);
			ИначеЕсли ЗначениеЗаполнено(Значение) И Значение.Количество() = 1 Тогда
				ДанныеНесколькоЗначений = Ложь;
				Данные = Значение[0];
			Иначе
				Данные = Неопределено;
				ДанныеСписок.Очистить();
			КонецЕсли;
			
			Элементы.Данные.Видимость = НЕ ДанныеНесколькоЗначений;
			Элементы.ДанныеСписок.Видимость = ДанныеНесколькоЗначений;
						
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("DataPresentation") Тогда
			// ПредставлениеДанных/DataPresentation
			ПредставлениеДанных = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("TransactionID") Тогда
			// Транзакция/TransactionID
			Транзакция = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("ServerName") Тогда
			// РабочийСервер/ServerName
			РабочиеСерверы = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "РабочийСервер");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Sessions") Тогда
			// Сеансы/Sessions
			СтрСеансы = Значение;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Port") Тогда
			// ОсновнойIPПорт/Port
			ОсновныеIPПорты = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "ОсновнойIPПорт");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("SyncPort") Тогда
			// ВспомогательныйIPПорт/SyncPort
			ВспомогательныеIPПорты = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы, "ВспомогательныйIPПорт");
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("Level") Тогда
			// Уровень/Level
			Для Каждого ЭлементСпискаЗначений Из Важность Цикл
				ЗначениеНастройки = Значение.НайтиПоЗначению(ЭлементСпискаЗначений.Значение);
				Если ЗначениеНастройки <> Неопределено Тогда
					ЭлементСпискаЗначений.Пометка = ЗначениеНастройки.Пометка;
				Иначе
					ЭлементСпискаЗначений.Пометка = Ложь;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ВРег(ИмяПараметра) = ВРег("TransactionStatus") Тогда
			// СтатусТранзакции/TransactionStatus
			Для Каждого ЭлементСпискаЗначений Из СтатусТранзакции Цикл
				ЗначениеНастройки = Значение.НайтиПоЗначению(ЭлементСпискаЗначений.Значение);
				Если ЗначениеНастройки <> Неопределено Тогда
					ЭлементСпискаЗначений.Пометка = ЗначениеНастройки.Пометка;
				Иначе
					ЭлементСпискаЗначений.Пометка = Ложь;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли Элементы.РазделениеДанныхСеанса.Видимость И ВРег(ИмяПараметра) = ВРег("SessionDataSeparation") Тогда
			// РазделениеДанныхСеанса/SessionDataSeparation
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				РазделениеДанныхСеанса = ДоступныеРазделителиДанныхСеанса(Значение);
			КонецЕсли;			
			
		ИначеЕсли Элементы.ОбластиДанных.Видимость И ВРег(ИмяПараметра) = ВРег("DataArea") Тогда
			// ОбластиДанных/DataArea
			ОбластиДанных = ДоступныеЗначенияОтбора(Значение, ДоступныеОтборы.РазделениеДанныхСеансаЗначения, 
				"ОбластьДанныхОсновныеДанные");
			РазделениеДанныхСеанса = СписокВсехРазделителей(ОбластиДанных);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьЗаголовкиГруппФормы();
	
КонецПроцедуры  

&НаСервере
Функция ДоступныеЗначенияОтбора(ЗначениеОтбора, ДоступныеОтборы, ИмяПараметраОтбора)

	Результат = Новый СписокЗначений();
	
	ДоступныеЗначенияОтбора = ДоступныеОтборы[ИмяПараметраОтбора];
	
	Если ТипЗнч(ДоступныеЗначенияОтбора) = Тип("Массив") Тогда
		Для Каждого ЭлементОтбора Из ЗначениеОтбора Цикл
			Если ДоступныеЗначенияОтбора.Найти(ЭлементОтбора.Значение) <> Неопределено Тогда
				Результат.Добавить(ЭлементОтбора.Значение, ЭлементОтбора.Представление);
			КонецЕсли;			
		КонецЦикла;
			
	ИначеЕсли ТипЗнч(ДоступныеЗначенияОтбора) = Тип("Соответствие") Тогда
		Для Каждого ЭлементОтбора Из ЗначениеОтбора Цикл
			Если ДоступныеЗначенияОтбора[ЭлементОтбора.Значение] <> Неопределено Тогда
				Результат.Добавить(ЭлементОтбора.Значение, ЭлементОтбора.Представление);
			КонецЕсли;
		КонецЦикла;
			
	ИначеЕсли ТипЗнч(ДоступныеЗначенияОтбора) = Тип("СписокЗначений") Тогда
		Для Каждого ЭлементОтбора Из ЗначениеОтбора Цикл
			НайденноеЗначение = ДоступныеЗначенияОтбора.НайтиПоЗначению(ЭлементОтбора.Представление);
			Если НайденноеЗначение <> Неопределено Тогда
				Результат.Добавить(НайденноеЗначение.Представление, НайденноеЗначение.Значение);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;	
	
КонецФункции

&НаСервереБезКонтекста
Функция ДоступныеОтборыЖурналаРегистрации()
	
	ОтбираемыеПараметры = "Пользователь, Событие, Компьютер, ИмяПриложения, Метаданные, РабочийСервер, 
	|	ОсновнойIPПорт, ВспомогательныйIPПорт, РазделениеДанныхСеанса.ОбластьДанныхОсновныеДанные"; 
	
	ДоступныеПараметрыОтбора = ПолучитьЗначенияОтбораЖурналаРегистрации(ОтбираемыеПараметры);
	
	СписокПользователейДляОтбора = Новый СписокЗначений;
	
	ЗначенияОтбораПользователи = ДоступныеПараметрыОтбора["Пользователь"];
	
	Для Каждого ЭлементСоответствия Из ЗначенияОтбораПользователи Цикл
		
		СписокПользователейДляОтбора.Добавить(ЭлементСоответствия.Значение, Строка(ЭлементСоответствия.Ключ));
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	ПустойПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени("");
	УстановитьПривилегированныйРежим(Ложь);
	СписокПользователейДляОтбора.Добавить(Пользователи.ПолноеИмяНеуказанногоПользователя(), 
		Строка(ПустойПользовательИБ.УникальныйИдентификатор));
	
	ДоступныеПараметрыОтбора["Пользователь"] = СписокПользователейДляОтбора;	
	
	Если НЕ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ДоступныеПараметрыОтбора.РазделениеДанныхСеансаЗначения["ОбластьДанныхОсновныеДанные"].Вставить("", НСтр("ru = '<Не задано>'"));
	КонецЕсли;
	
	ОбработатьДоступныеПараметрыОтбора(ДоступныеПараметрыОтбора);
	
	Возврат ДоступныеПараметрыОтбора;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОбработатьДоступныеПараметрыОтбора(ДоступныеПараметрыОтбора)
	
	Для Каждого ПараметрОтбора Из ДоступныеПараметрыОтбора Цикл
		Если ПараметрОтбора.Ключ = "РазделениеДанныхСеансаЗначения" Тогда
			ПреобразованныйНабор = Новый Соответствие;
			Для Каждого ЭлементСоответствия Из ПараметрОтбора.Значение["ОбластьДанныхОсновныеДанные"] Цикл
				ПреобразованныйНабор.Вставить(Формат(ЭлементСоответствия.Ключ, "ЧГ="), ЭлементСоответствия.Значение);
			КонецЦикла;
			
			ПараметрОтбора.Значение["ОбластьДанныхОсновныеДанные"] = ПреобразованныйНабор;

		КонецЕсли
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоступныеРазделителиДанныхСеанса(Значение)
	
	Результат = Новый СписокЗначений;
	
	РазделениеДанныхСоответствие = Новый Соответствие;
	Если Значение.Количество() > 0 Тогда
		Для Каждого РазделительСеанса Из Значение Цикл
			РазделениеДанныхМассив = СтрРазделить(РазделительСеанса.Значение, "=");
			РазделениеДанныхСоответствие.Вставить(РазделениеДанныхМассив[0], РазделениеДанныхМассив[1]);
		КонецЦикла;                     	
	КонецЕсли;
	
	Если РазделениеДанныхСоответствие.Количество()  = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.НеИспользовать Тогда
			Продолжить;
		КонецЕсли;
		
		НайденноеЗначениеРазделителя = РазделениеДанныхСоответствие[ОбщийРеквизит.Имя];
		Если НайденноеЗначениеРазделителя <> Неопределено Тогда
			ЗначениеРазделителя = ОбщийРеквизит.Имя + "=" + НайденноеЗначениеРазделителя;
			ПредставлениеРазделителя = ОбщийРеквизит.Синоним + " = " + НайденноеЗначениеРазделителя;
			Результат.Добавить(ЗначениеРазделителя, ПредставлениеРазделителя);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращаемое значение:
//  Строка
//
&НаКлиентеНаСервереБезКонтекста
Функция ОсновнойIPПорт()
	Возврат "ОсновнойIPПорт";
КонецФункции


#КонецОбласти
