﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму с доступными командами.
//
// Параметры:
//   ПараметрКоманды - Произвольный - передается "как есть" из параметров обработчика команды.
//   ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - передается "как есть" из параметров обработчика команды.
//   Вид - Строка - вид обработки, который можно получить из серии функций:
//       ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработки<...>.
//   ИмяРаздела - Строка - имя раздела командного интерфейса, из которого вызывается команда.
//
Процедура ОткрытьФормуКомандДополнительныхОтчетовИОбработок(ПараметрКоманды, ПараметрыВыполненияКоманды, Вид, ИмяРаздела = "") Экспорт
	
	ОбъектыНазначения = Новый СписокЗначений;
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда // назначаемая обработка
		ОбъектыНазначения.ЗагрузитьЗначения(ПараметрКоманды);
	ИначеЕсли ПараметрКоманды <> Неопределено Тогда
		ОбъектыНазначения.Добавить(ПараметрКоманды);
	КонецЕсли;
	
	Параметры = Новый Структура("ОбъектыНазначения, Вид, ИмяРаздела, РежимОткрытияОкна");
	Параметры.ОбъектыНазначения = ОбъектыНазначения;
	Параметры.Вид = Вид;
	Параметры.ИмяРаздела = ИмяРаздела;
	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения") Тогда // назначаемая обработка
		Параметры.Вставить("ИмяФормы", ПараметрыВыполненияКоманды.Источник.ИмяФормы);
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыВыполненияКоманды) = Тип("ПараметрыВыполненияКоманды") Тогда
		ФормаСсылка = ПараметрыВыполненияКоманды.НавигационнаяСсылка;
	Иначе
		ФормаСсылка = Неопределено;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ДополнительныеОтчетыИОбработки", Параметры,
		ПараметрыВыполненияКоманды.Источник,,, ФормаСсылка);
	
КонецПроцедуры

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры:
//   ДополнительныйОтчет - СправочникСсылка.ДополнительныеОтчетыИОбработки
//   КлючВарианта - Строка - имя варианта дополнительного отчета.
//
Процедура ОткрытьВариантДополнительногоОтчета(ДополнительныйОтчет, КлючВарианта) Экспорт
	
	Если ТипЗнч(ДополнительныйОтчет) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОтчета = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ДополнительныйОтчет);
	ИмяФормы = СтрШаблон("ВнешнийОтчет.%1.Форма", ИмяОтчета);
	Уникальность = СтрШаблон("ВнешнийОтчет.%1/КлючВарианта.%2", ИмяОтчета, КлючВарианта);
	ПараметрыОткрытия = Новый Структура("КлючВарианта", КлючВарианта);
	ОткрытьФорму(ИмяФормы, ПараметрыОткрытия, Неопределено, Уникальность);
	
КонецПроцедуры

// Возвращает пустую структуру параметров выполнения команды в фоне.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка выполняемой дополнительной обработки или отчета.
//
// Возвращаемое значение:
//   Структура - шаблон параметров выполнения команды в фоне:
//      * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - передается "как есть" из
//                                                                                          параметров формы.
//      * СопровождающийТекст - Строка - текст длительной операции.
//      * ОбъектыНазначения - Массив - ссылки объектов, для которых выполняется команда.
//          Используется для назначаемых дополнительных обработок.
//      * СозданныеОбъекты - Массив - ссылки объектов, созданных в процессе выполнения команды.
//          Используется для назначаемых дополнительных обработок вида "Создание связанных объектов".
//      * ФормаВладелец - ФормаКлиентскогоПриложения - форма объекта или списка, из которой была вызвана команда.
//
Функция ПараметрыВыполненияКомандыВФоне(Ссылка) Экспорт
	
	Результат = Новый Структура("ДополнительнаяОбработкаСсылка", Ссылка);
	Результат.Вставить("СопровождающийТекст");
	Результат.Вставить("ОбъектыНазначения");
	Результат.Вставить("СозданныеОбъекты");
	Результат.Вставить("ФормаВладелец");
	Возврат Результат;
	
КонецФункции

// Выполняет команду ИдентификаторКоманды в фоне с помощью механизма длительных операций.
// Для использования в формах внешних отчетов и обработок.
//
// Параметры:
//   ИдентификаторКоманды - Строка - имя команды, как оно задано в функции СведенияОВнешнейОбработке модуля объекта.
//   ПараметрыКоманды - Структура - параметры выполнения команды.
//       Состав параметров описан в функции ПараметрыВыполненияКомандыВФоне.
//       Также включает в себя служебный параметр, зарезервированный подсистемой:
//         * ИдентификаторКоманды - Строка - имя выполняемой команды. Соответствует параметру ИдентификаторКоманды.
//       Помимо стандартных параметров может содержать пользовательские для использования в обработчике команды.
//       При добавлении собственных параметров рекомендуется использовать префикс в их именах,
//       исключающий конфликты со стандартными параметрами, например "Контекст...".
//   Обработчик - см. ДлительныеОперацииКлиент.ОжидатьЗавершение.ОповещениеОЗавершении
//
// Пример:
//	&НаКлиенте
//	Процедура ОбработчикКоманды(Команда)
//		ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
//		ПараметрыКоманды.СопровождающийТекст = НСтр("ru = 'Выполняется команда...'");
//		Обработчик = Новый ОписаниеОповещения("<ИмяЭкспортнойПроцедуры>", ЭтотОбъект);
//		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне(Команда.Имя, ПараметрыКоманды, Обработчик);
//	КонецПроцедуры
//
Процедура ВыполнитьКомандуВФоне(Знач ИдентификаторКоманды, Знач ПараметрыКоманды, Знач Обработчик) Экспорт
	
	ИмяПроцедуры = "ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне";
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		"ИдентификаторКоманды",
		ИдентификаторКоманды,
		Тип("Строка"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		"ПараметрыКоманды",
		ПараметрыКоманды,
		Тип("Структура"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		"ПараметрыКоманды.ДополнительнаяОбработкаСсылка",
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "ДополнительнаяОбработкаСсылка"),
		Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		"Обработчик",
		Обработчик,
		Новый ОписаниеТипов("ОписаниеОповещения, ФормаКлиентскогоПриложения"));
	
	ПараметрыКоманды.Вставить("ИдентификаторКоманды", ИдентификаторКоманды);
	ПолучатьРезультат = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "ПолучатьРезультат", Ложь);
	
	Форма = Неопределено;
	Если ПараметрыКоманды.Свойство("ФормаВладелец", Форма) Тогда
		ПараметрыКоманды.ФормаВладелец = Неопределено;
	КонецЕсли;
	Если ТипЗнч(Обработчик) = Тип("ОписаниеОповещения") Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Обработчик.Модуль",
			Обработчик.Модуль,
			Тип("ФормаКлиентскогоПриложения"));
		Форма = ?(Форма <> Неопределено, Форма, Обработчик.Модуль);
	Иначе
		Форма = Обработчик;
		Обработчик = Неопределено;
		ПолучатьРезультат = Истина; // для обратной совместимости
	КонецЕсли;
	
	Задание = ДополнительныеОтчетыИОбработкиВызовСервера.ЗапуститьДлительнуюОперацию(Форма.УникальныйИдентификатор, ПараметрыКоманды);
	
	СопровождающийТекст = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "СопровождающийТекст", "");
	Заголовок = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "Заголовок");
	Если ЗначениеЗаполнено(Заголовок) Тогда
		СопровождающийТекст = СокрЛП(Заголовок + Символы.ПС + СопровождающийТекст);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(СопровождающийТекст) Тогда
		СопровождающийТекст = НСтр("ru = 'Команда выполняется.'");
	КонецЕсли;
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	НастройкиОжидания.ТекстСообщения       = СопровождающийТекст;
	НастройкиОжидания.ВыводитьОкноОжидания = Истина;
	НастройкиОжидания.ПолучатьРезультат    = ПолучатьРезультат; // для обратной совместимости
	НастройкиОжидания.ВыводитьСообщения    = Истина;
	НастройкиОжидания.ВыводитьПрогрессВыполнения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать обработчик оповещения
// (смотри параметр Обработчик в процедуре ВыполнитьКомандуВФоне)
// вместо использования события ОбработкаВыбора формы владельца совместно с анализом источника:
// ИсточникВыбора.ИмяФормы = ДополнительныеОтчетыИОбработкиКлиент.ИмяФормыДлительнойОперации().
//
// Возвращает имя формы для идентификации результата выполнения длительной операции.
//
// Возвращаемое значение:
//   Строка - см. ВыполнитьКомандуВФоне.
//
Функция ИмяФормыДлительнойОперации() Экспорт
	
	Возврат "ОбщаяФорма.ДлительнаяОперация";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму подбора дополнительных отчетов.
// Места использования:
//   Справочник.РассылкиОтчетов.Форма.ФормаЭлемента.ДобавитьДополнительныйОтчет.
//
// Параметры:
//   ЭлементФормы - Произвольный - элемент формы, в который выполняется подбор элементов.
//
Процедура РассылкаОтчетовПодборДопОтчета(ЭлементФормы) Экспорт
	
	ДополнительныйОтчет = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет");
	Отчет               = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет");
	
	ОтборПоВиду = Новый СписокЗначений;
	ОтборПоВиду.Добавить(ДополнительныйОтчет, ДополнительныйОтчет);
	ОтборПоВиду.Добавить(Отчет, Отчет);
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.Независимый);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("Отбор",              Новый Структура("Вид", ОтборПоВиду));
	
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.ФормаВыбора", ПараметрыФормыВыбора, ЭлементФормы);
	
КонецПроцедуры

// Обработчик внешней команды печати.
//
// Параметры:
//  ВыполняемаяКоманда - Структура        - структура из строки таблицы команд, см.
//                                        ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати.
//  Форма            - ФормаКлиентскогоПриложения - форма, в которой выполняется команда печати.
//
Процедура ВыполнитьНазначаемуюКомандуПечати(ВыполняемаяКоманда, Форма) Экспорт
	
	// Перенос дополнительных параметров, переданных этой подсистемой, в корень структуры.
	Для Каждого КлючИЗначение Из ВыполняемаяКоманда.ДополнительныеПараметры Цикл
		ВыполняемаяКоманда.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	// Запись фиксированных параметров.
	ВыполняемаяКоманда.Вставить("ЭтоОтчет", Ложь);
	ВыполняемаяКоманда.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма"));
	
	// Запуск метода обработки, соответствующего контексту команды.
	ВариантЗапуска = ВыполняемаяКоманда.ВариантЗапуска;
	Если ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	ИначеЕсли ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	Иначе
		ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	КонецЕсли;
	
КонецПроцедуры

// Открывает список команд дополнительных отчетов и обработок для указанных объектов.
//
// Параметры:
//   Объекты - Массив из ЛюбаяСсылка - объекты, для которых выполняется команда.
//   ПараметрыВыполнения - Структура:
//       * ОписаниеКоманды - Структура:
//          ** Идентификатор - Строка - идентификатор команды.
//          ** Представление - Строка - представление команды в форме.
//          ** Имя - Строка - имя команды в форме.
//          ** ДополнительныеПараметры - см. ДополнительныеОтчетыИОбработки.ДополнительныеПараметрыКоманды
//       * Форма - ФормаКлиентскогоПриложения - форма, из которой была вызвана команда.
//       * Источник - ДанныеФормыСтруктура
//                  - ТаблицаФормы - объект или список формы с полем "Ссылка".
//
Процедура ОткрытьСписокКоманд(Знач Объекты, Знач ПараметрыВыполнения) Экспорт
	Контекст = Новый Структура;
	Контекст.Вставить("Источник", ПараметрыВыполнения.Форма);
	Вид = ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.Вид;
	ОткрытьФормуКомандДополнительныхОтчетовИОбработок(Объекты, Контекст, Вид);
КонецПроцедуры

// См. ДополнительныеОтчетыИОбработки.ОбработчикКомандыЗаполнения
Процедура ОбработчикКомандыЗаполнения(Знач МассивСсылок, Знач ПараметрыВыполнения) Экспорт
	Форма              = ПараметрыВыполнения.Форма;
	Объект             = ПараметрыВыполнения.Источник;
	ВыполняемаяКоманда = ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры; // См. ДополнительныеОтчетыИОбработки.ДополнительныеПараметрыКомандыЗаполнения
	

	ПараметрыВызоваСервера = Новый Структура;
	ПараметрыВызоваСервера.Вставить("ИдентификаторКоманды",          ВыполняемаяКоманда.Идентификатор);
	ПараметрыВызоваСервера.Вставить("ДополнительнаяОбработкаСсылка", ВыполняемаяКоманда.Ссылка);
	ПараметрыВызоваСервера.Вставить("ОбъектыНазначения",             Новый Массив);
	ПараметрыВызоваСервера.Вставить("ИмяФормы",                      Форма.ИмяФормы);
	ПараметрыВызоваСервера.ОбъектыНазначения.Добавить(Объект.Ссылка);
	
	ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда);
	
	// Контроль за результатом выполнения поддерживается только для серверных методов.
	// Если открывается форма или вызывается клиентский метод, то вывод результата выполнения выполняется обработкой.
	Если ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		
		ОткрытьФормуДополнительногоОтчетаОбработки(ВыполняемаяКоманда.Ссылка, ВыполняемаяКоманда.ЭтоОтчет,
			ПараметрыВызоваСервера, Форма);
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		
		ФормаВнешнегоОбъекта = ФормаДополнительногоОтчетаОбработки(ВыполняемаяКоманда.Ссылка, ВыполняемаяКоманда.ЭтоОтчет,
			ПараметрыВызоваСервера, Форма);
		Если ФормаВнешнегоОбъекта <> Неопределено Тогда
			ФормаВнешнегоОбъекта.ВыполнитьКоманду(ПараметрыВызоваСервера.ИдентификаторКоманды, ПараметрыВызоваСервера.ОбъектыНазначения);
		КонецЕсли;
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
		Или ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
		
		ПараметрыВызоваСервера.Вставить("РезультатВыполнения", Новый Структура);
		ДополнительныеОтчетыИОбработкиВызовСервера.ВыполнитьКоманду(ПараметрыВызоваСервера, Неопределено);
		
		ПараметрыПриложения.Вставить(ИмяПараметраПриложенияФормаВладелецВыполняемойКоманды(), Форма);
		ПодключитьОбработчикОжидания("ПриЗавершенииВыполненияКомандыЗаполнения", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьСписокДополнительныхОтчетовИОбработок() Экспорт
	
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуДополнительногоОтчетаОбработки(ДополнительныйОтчетОбработка, ЭтоОтчет, ПараметрыФормы, ФормаВладелец)

	ИмяФормы = ИмяФормыДополнительногоОтчетаОбработки(ДополнительныйОтчетОбработка, ЭтоОтчет);
	Если ПустаяСтрока(ИмяФормы) Тогда
		Возврат;
	КонецЕсли;
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, ФормаВладелец);

КонецПроцедуры

Функция ФормаДополнительногоОтчетаОбработки(ДополнительныйОтчетОбработка, ЭтоОтчет, ПараметрыФормы, ФормаВладелец)

	ИмяФормы = ИмяФормыДополнительногоОтчетаОбработки(ДополнительныйОтчетОбработка, ЭтоОтчет);
	Если ПустаяСтрока(ИмяФормы) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ПолучитьФорму(ИмяФормы, ПараметрыФормы, ФормаВладелец); // АПК:65 Для обратной совместимости: вызов клиентской процедуры обработки.

КонецФункции

Функция ИмяФормыДополнительногоОтчетаОбработки(ДополнительныйОтчетОбработка, ЭтоОтчет)

	Если ТипЗнч(ДополнительныйОтчетОбработка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяВнешнегоОбъекта = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ДополнительныйОтчетОбработка);
	Возврат ?(ЭтоОтчет, СтрШаблон("ВнешнийОтчет.%1.Форма", ИмяВнешнегоОбъекта),
		СтрШаблон("ВнешняяОбработка.%1.Форма", ИмяВнешнегоОбъекта));

КонецФункции

Процедура ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда)
	Если ВыполняемаяКоманда.ПоказыватьОповещение Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Команда выполняется...'"), , ВыполняемаяКоманда.Представление);
	КонецЕсли;
КонецПроцедуры

Процедура ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	ПараметрыОбработки = Новый Структура("ИдентификаторКоманды, ДополнительнаяОбработкаСсылка, ИмяФормы, КлючСессии");
	ПараметрыОбработки.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыОбработки.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыОбработки.ИмяФормы                      = ?(Форма = Неопределено, Неопределено, Форма.ИмяФормы);
	ПараметрыОбработки.КлючСессии = ВыполняемаяКоманда.Ссылка.УникальныйИдентификатор();
	
	Если ТипЗнч(ОбъектыНазначения) = Тип("Массив") Тогда
		ПараметрыОбработки.Вставить("ОбъектыНазначения", ОбъектыНазначения);
	КонецЕсли;
	
#Если ТолстыйКлиентОбычноеПриложение Тогда
	ВнешняяОбработка = ДополнительныеОтчетыИОбработкиВызовСервера.ОбъектВнешнейОбработки(ВыполняемаяКоманда.Ссылка);
	ФормаОбработки = ВнешняяОбработка.ПолучитьФорму(, Форма); // АПК:65 Для улучшения диагностики.
	Если ФормаОбработки = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для отчета или обработки ""%1"" не назначена основная форма,
			|или основная форма не предназначена для запуска в обычном приложении.
			|Команда ""%2"" не может быть выполнена.'"),
			Строка(ВыполняемаяКоманда.Ссылка),
			ВыполняемаяКоманда.Представление);
	КонецЕсли;
	ФормаОбработки.Открыть();
	ФормаОбработки = Неопределено;
#Иначе
	ОткрытьФормуДополнительногоОтчетаОбработки(ВыполняемаяКоманда.Ссылка, ВыполняемаяКоманда.ЭтоОтчет, ПараметрыОбработки, Форма);
#КонецЕсли

КонецПроцедуры

Процедура ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	
	ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда);
	
	ПараметрыОбработки = Новый Структура("ИдентификаторКоманды, ДополнительнаяОбработкаСсылка, ИмяФормы");
	ПараметрыОбработки.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыОбработки.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыОбработки.ИмяФормы                      = ?(Форма = Неопределено, Неопределено, Форма.ИмяФормы);
	
	Если ТипЗнч(ОбъектыНазначения) = Тип("Массив") Тогда
		ПараметрыОбработки.Вставить("ОбъектыНазначения", ОбъектыНазначения);
	КонецЕсли;
	
#Если ТолстыйКлиентОбычноеПриложение Тогда
	ВнешняяОбработка = ДополнительныеОтчетыИОбработкиВызовСервера.ОбъектВнешнейОбработки(ВыполняемаяКоманда.Ссылка);
	ФормаОбработки = ВнешняяОбработка.ПолучитьФорму(, Форма); // АПК:65 Для улучшения диагностики.
	Если ФормаОбработки = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для отчета или обработки ""%1"" не назначена основная форма,
			|или основная форма не предназначена для запуска в обычном приложении.
			|Команда ""%2"" не может быть выполнена.'"),
			Строка(ВыполняемаяКоманда.Ссылка),
			ВыполняемаяКоманда.Представление);
	КонецЕсли;
#Иначе
	ФормаОбработки = ФормаДополнительногоОтчетаОбработки(ВыполняемаяКоманда.Ссылка, ВыполняемаяКоманда.ЭтоОтчет, ПараметрыОбработки, Форма);
#КонецЕсли
	
	Если ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка")
		Или ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор);
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов") Тогда
		
		СозданныеОбъекты = Новый Массив;
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения, СозданныеОбъекты);
		
		ТипыСозданныхОбъектов = Новый Массив;
		Для Каждого СозданныйОбъект Из СозданныеОбъекты Цикл
			Тип = ТипЗнч(СозданныйОбъект);
			Если ТипыСозданныхОбъектов.Найти(Тип) = Неопределено Тогда
				ТипыСозданныхОбъектов.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Тип Из ТипыСозданныхОбъектов Цикл
			ОповеститьОбИзменении(Тип);
		КонецЦикла
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма") Тогда
		
		ФормаОбработки.Печать(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
		ТипыИзмененныхОбъектов = Новый Массив;
		Для Каждого ИзмененныйОбъект Из ОбъектыНазначения Цикл
			Тип = ТипЗнч(ИзмененныйОбъект);
			Если ТипыИзмененныхОбъектов.Найти(Тип) = Неопределено Тогда
				ТипыИзмененныхОбъектов.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Тип Из ТипыИзмененныхОбъектов Цикл
			ОповеститьОбИзменении(Тип);
		КонецЦикла
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
	КонецЕсли;
	
	ФормаОбработки = Неопределено;
	
КонецПроцедуры

// Формирует табличный документ в форме подсистемы "Печать".
Процедура ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	
	СтандартнаяОбработка = Истина;
	// АПК:222-выкл Для обратной совместимости.
	ДополнительныеОтчетыИОбработкиКлиентПереопределяемый.ПередВыполнениемКомандыПечатиВнешнейПечатнойФормы(
		ОбъектыНазначения, СтандартнаяОбработка);
	// АПК:222-вкл
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатьюСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеПечатьюСлужебныйКлиент");
		МодульУправлениеПечатьюСлужебныйКлиент.ВыполнитьОткрытиеПечатнойФормы(
			ВыполняемаяКоманда.Ссылка,
			ВыполняемаяКоманда.Идентификатор,
			ОбъектыНазначения,
			Форма,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Показывает диалог установки расширения, затем выгружает данные дополнительного отчета или обработки.
//
// Параметры:
//   ПараметрыВыгрузки - Структура:
//   * Ссылка - ЛюбаяСсылка
//
Процедура ВыгрузитьВФайл(ПараметрыВыгрузки) Экспорт
	Перем Адрес;
	
	ПараметрыВыгрузки.Свойство("АдресДанныхОбработки", Адрес);
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Адрес = ДополнительныеОтчетыИОбработкиВызовСервера.ПоместитьВХранилище(ПараметрыВыгрузки.Ссылка, Неопределено);
	КонецЕсли;
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.ТекстПредложения = НСтр("ru = 'Для сохранения внешней обработки (отчета) в файл рекомендуется установить расширение для работы с 1С:Предприятием.'");
	ПараметрыСохранения.Диалог.Фильтр = ДополнительныеОтчетыИОбработкиКлиентСервер.ФильтрДиалоговВыбораИСохранения();
	ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Укажите файл'");
	ПараметрыСохранения.Диалог.ИндексФильтра = ?(ПараметрыВыгрузки.ЭтоОтчет, 1, 2);
	ПараметрыСохранения.Диалог.ПолноеИмяФайла = ПараметрыВыгрузки.ИмяФайла;
	
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, Адрес, ПараметрыВыгрузки.ИмяФайла, ПараметрыСохранения);
	
КонецПроцедуры

// Для процедуры ОбработчикКомандыЗаполнения
Процедура ОбновитьДанныеВФорме() Экспорт
	
	ИмяПараметра = ИмяПараметраПриложенияФормаВладелецВыполняемойКоманды();
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ПараметрыПриложения[ИмяПараметра];
	Форма.Прочитать();
	
	ПараметрыПриложения[ИмяПараметра] = Неопределено;
	
КонецПроцедуры

Функция ИмяПараметраПриложенияФормаВладелецВыполняемойКоманды()
	
	Возврат "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки.ФормаВладелецВыполняемойКоманды";
	
КонецФункции

#КонецОбласти
