
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МаксимальнаяДоля = Константы.МаксимальнаяДоляОплатыБаллами.Получить();
	
	Если БаллыКСписанию <> 0 Тогда

		Если БаллыКСписанию > Цена Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Списываемые баллы не должны превышать цену билета";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "БаллыКСписанию";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если Цена <> 0 Тогда
			Доля = БаллыКСписанию / Цена * 100;
			Если Доля > МаксимальнаяДоля Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон("Доля списываемых баллов от цены больше допустимой (%1%%)", МаксимальнаяДоля);
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = "БаллыКСписанию";
				Сообщение.Сообщить();
			КонецЕсли;
		КонецЕсли;


	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	СвойстваНоменклатуры = СвойстваНоменклатуры(Номенклатура);
	// регистр АктивныеПосещения
	Движения.АктивныеПосещения.Записывать = Истина;
	Движение = Движения.АктивныеПосещения.Добавить();
	Движение.Период = Дата;
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Основание = Ссылка;
	Движение.ВидАттракциона = СвойстваНоменклатуры.ВидАттракциона;
	Движение.КоличествоПосещений = СвойстваНоменклатуры.КоличествоПосещений;
	
	// регистр Продажи
	Движения.Продажи.Записывать = Истина;
	Движение = Движения.Продажи.Добавить();
	Движение.Период = Дата;
	Движение.Клиент = Клиент;
	Движение.ВидАттракциона = СвойстваНоменклатуры.ВидАттракциона;
	Движение.Сумма = СуммаДокумента;
	
	НачислитьСписатьБонусныеБаллы(Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачислитьСписатьБонусныеБаллы(Отказ)
	
КонецПроцедуры

Функция СвойстваНоменклатуры(Номенклатура)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.ВидАттракциона,
	|	Номенклатура.КоличествоПосещений
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Номенклатура);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Результат = Новый Структура;

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат.Вставить("ВидАттракциона", ВыборкаДетальныеЗаписи.ВидАттракциона);
		Результат.Вставить("КоличествоПосещений", ВыборкаДетальныеЗаписи.КоличествоПосещений);
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли