﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
		Если Параметры <> Неопределено И Параметры.Свойство("ОткрытаПоСценарию") Тогда
			СтандартнаяОбработка = Ложь;
			ВидИнформации = Параметры.ВидКонтактнойИнформации;
			ВыбраннаяФорма = ИмяФормыВводаКонтактнойИнформации(ВидИнформации);
			
			Если ВыбраннаяФорма = Неопределено Тогда
				ВызватьИсключение  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не обрабатываемый тип адреса: ""%1""'"), ВидИнформации);
			КонецЕсли;
		КонецЕсли;
		
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает имя формы для редактирования типа контактной информации.
//
// Параметры:
//      ВидИнформации - ПеречислениеСсылка.ТипыКонтактнойИнформации
//                    - СправочникСсылка.ВидыКонтактнойИнформации -
//                      запрашиваемый тип.
//
// Возвращаемое значение:
//      Строка - полное имя формы.
//
Функция ИмяФормыВводаКонтактнойИнформации(Знач ВидИнформации)
	
	ТипИнформации = УправлениеКонтактнойИнформациейСлужебныйПовтИсп.ТипВидаКонтактнойИнформации(ВидИнформации);
	
	Если ТипИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		
		РасширенныйВводКонтактнойИнформации = Метаданные.Обработки.Найти("РасширенныйВводКонтактнойИнформации");
		Если РасширенныйВводКонтактнойИнформации = Неопределено Тогда
			Возврат Метаданные.Обработки.ВводКонтактнойИнформации.Формы.ВводАдреса.ПолноеИмя();
		Иначе
			Возврат РасширенныйВводКонтактнойИнформации.Формы.Найти("ВводАдреса").ПолноеИмя();
		КонецЕсли;
		
	ИначеЕсли ТипИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
		  Или ТипИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
		Возврат Метаданные.Обработки.ВводКонтактнойИнформации.Формы.ВводТелефона.ПолноеИмя();
	ИначеЕсли ТипИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
		Возврат Метаданные.Обработки.ВводКонтактнойИнформации.Формы.ВебСайт;
	
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли


