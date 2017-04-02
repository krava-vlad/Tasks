﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Пользователи
	Если Не Пользователи.ОбщиеНастройкиВходаИспользуются() Тогда
		Элементы.ГруппаНастройкиВхода.Видимость = Ложь;
		Элементы.ГруппыПользователейИНастройкиВхода.Группировка
			= ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ГоризонтальныйОтступ2.Видимость = Ложь;
		Элементы.ГруппаНастройкиВходаВнешнихПользователей.Видимость = Ложь;
		Элементы.ИспользованиеВнешнихПользователейИНастройкиВхода.Группировка
			= ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.НастройкаВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.ИспользоватьГруппыПользователей.Доступность = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УпрощенныйИнтерфейс = УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	Элементы.ГруппыДоступа.Видимость       = НЕ УпрощенныйИнтерфейс;
	Элементы.ГруппыПользователей.Видимость = НЕ УпрощенныйИнтерфейс;
	
	Если ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		Элементы.ОграничиватьДоступНаУровнеЗаписей.Доступность = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// СтандартныеПодсистемы.УправлениеДоступом
&НаКлиенте
Процедура ИспользоватьГруппыПользователейПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.УправлениеДоступом
&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзменении(Элемент)
	
	Если НаборКонстант.ОграничиватьДоступНаУровнеЗаписей Тогда
		
		ТекстВопроса =
			НСтр("ru='Включить ограничение доступа на уровне записей?"
""
"Потребуется заполнение данных, которое будет выполняться частями"
"регламентным заданием ""Заполнение данных для ограничения доступа"""
"(ход выполнения в журнале регистрации)."
""
"Выполнение может сильно замедлить работу программы и выполняться"
"от нескольких секунд до многих часов (в зависимости от объема данных).';en='Do you want to enable"
""
"the access restriction on the write level?"
"Filling data will be required which will"
"be executed by schedule job parts ""Filling data for access restriction"" (perform step in events log monitor)."
""
"Execution can greatly slow down the"
"application work and it is executed from a few seconds to many hours (depending on data volume).'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.Пользователи
&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьВнешнихПользователей Тогда
		
		ТекстВопроса =
			НСтр("ru = 'Разрешить доступ внешним пользователям?
			           |
			           |При входе в программу список выбора пользователей станет пустым
			           |(реквизит ""Показывать в списке выбора"" в карточках всех
			           | пользователей будет очищен и скрыт).'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ТекстВопроса =
			НСтр("ru = 'Запретить доступ внешним пользователям?
			           |
			           |Реквизит ""Вход в программу разрешен"" будет
			           |очищен в карточках всех внешних пользователей.'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Пользователи
&НаКлиенте
Процедура СправочникВнешниеПользователи(Команда)
	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВходаПользователей(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкиВходаПользователей", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВходаВнешнихПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьНастройкиВнешнихПользователей", Истина);
	
	ОткрытьФорму("ОбщаяФорма.НастройкиВходаПользователей", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	МассивИменКонстант = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Для Каждого КонстантаИмя Из МассивИменКонстант Цикл
		Если КонстантаИмя <> "" Тогда
			Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом
&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ОграничиватьДоступНаУровнеЗаписей = Ложь;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.Пользователи
&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ИспользоватьВнешнихПользователей = Ложь;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	МассивИменКонстант = Новый Массив;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	НачатьТранзакцию();
	Попытка
		
		КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
		МассивИменКонстант.Добавить(КонстантаИмя);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат МассивИменКонстант;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		ТекущееЗначение  = КонстантаМенеджер.Получить();
		
		Если ТекущееЗначение <> КонстантаЗначение Тогда
			Попытка
				КонстантаМенеджер.Установить(КонстантаЗначение);
			Исключение
				НаборКонстант[КонстантаИмя] = ТекущееЗначение;
				ВызватьИсключение;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	// СтандартныеПодсистемы.Пользователи
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнешнихПользователей" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьВнешниеПользователи.Доступность         = НаборКонстант.ИспользоватьВнешнихПользователей;
		Элементы.НастройкиВходаВнешнихПользователей.Доступность = НаборКонстант.ИспользоватьВнешнихПользователей;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	
	
КонецПроцедуры

#КонецОбласти
