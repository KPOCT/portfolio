<?php
	$doc = new DOMDocument('5.0', 'utf-8'); // С помощью конструктора создаём объект doc, в который в следующей строке поместим DOM
	$doc->loadHTMLFile('../template.html'); // Считываем шаблон

	include '../template.php'; // Подключаем файл с функциями SetTitle(), Fill---(), ...
	
	SetTitle($doc, 'Задача №1'); // Изменяем значение тега <title>
	FillHeader($doc); // Заполняем <div id='header'>
	FillNav($doc); // Заполняем <div id='nav'>
/**************************Заполнение основной части***************************/
	$main = $doc->getElementById('main'); // Основной контент, в который входит задание и решение
	/******************Задание*****************/
		$assignment = createElement( $doc, $main, 'div', array('id' => 'assignment') );
		
		$h3 = createElement( $doc, $assignment, 'h3', '', 'Задача №1' ); // Заголовок задания

		$assignment->appendChild($doc->createTextNode('Величина Z содержит значение объема информации в байтах.'));
		createElement( $doc, $assignment, 'br' );
		$assignment->appendChild($doc->createTextNode('Написать программу, которая переводит значение Z в более крупные единицы измерения информации (Кбайт, Мбайт и т.д.).'));
		createElement( $doc, $assignment, 'br' );
		$assignment->appendChild($doc->createTextNode('Текущее значение величины Z нужно вводить в текстовое поле.'));
	/*******************************************/
	createElement( $doc, $main, 'hr' );
	/******************Решение*****************/
		$solve = createElement( $doc, $main, 'div', array( 'id' => 'solve') );

		$form = createElement
		(
			$doc,
			$solve,
			'form',
			array
			(
				'class' => 'row col-xs-6',
				'action' => '1.php',
				'method' => 'post'
			)
		); // Форма, в которую поместятся элементы input

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'class' => 'input btn',
				'type' => 'number',
				'name' => 'NumBytes',
				'required' => '',
				'placeholder' => 'Количество байт'
			)
		);

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'class' => 'btn',
				'type' => 'submit',
				'value' => 'OK'
			)
		);

		if(isset($_POST['NumBytes']) && is_numeric($_POST['NumBytes']))
		{
			$result = createElement( $doc, $solve, 'div', array( 'id' => 'result', 'class' => 'row cocol-xs-6' ) );

			createElement
			(
				$doc,
				$result,
				'p',
				array( 'class' => 'label label-info' ),
				str_num_format($_POST['NumBytes'], 0) . ' Б'
			);

			createElement
			(
				$doc,
				$result,
				'p',
				array( 'class' => 'label label-info' ),
				'='
			);

			createElement
			(
				$doc,
				$result,
				'p',
				array( 'class' => 'label label-info' ),
				convertMemory($_POST['NumBytes'])
			);
		}
	/*******************************************/

/*******************************************************************************/
	FillFooter($doc); // Заполняем <div id='footer'>
	PrintHTML($doc); // Выводим обработаный HTML код
?>

<?php
	function str_num_format( $number, $decimals = 2, $dec_point = ',', $thousands_sep = ' ' )
	{
		$array = preg_split("/[.]/", $number); // Разделяем на 2 части (целую и дробную)

		while( $array[0][0] == '0' && strlen($array[0])-1)
		{
			$array[0] = substr($array[0], 1); // Убираем первый 0
		}

		$array[1] = substr($array[1], 0, $decimals); // Округляем (обрезаем, если точнее) дробную

		$array[0] = preg_replace('/\B(?=(?:\d{3})+(?!\d))/', $thousands_sep, $array[0]); // Разделяем на разряды целую часть
		$array[1] = preg_replace('/\B(?=(?:\d{3})+(?!\d))/', $thousands_sep, $array[1]); // Разделяем на разряды дробную часть
		return $array[0] . ( $array[1] ? $dec_point . $array[1] : '' ); // Формируем результирующую строку вида: <целая_часть><разделитель><дробная_часть>
	}

	function convertMemory($NumBytes)
	{
		if(abs($NumBytes/pow(1024, 8)) > 0.8)
		{
			return number_format($NumBytes/pow(1024, 8), 2,',',' ') . ' ЙБ';
		}
		else if(abs($NumBytes/pow(1024, 7)) > 0.8)
		{
			return number_format($NumBytes/pow(1024, 7), 2,',',' ') . ' ЗБ';
		}
		else if(abs($NumBytes/pow(1024, 6)) > 0.8)
		{
			return number_format($NumBytes/pow(1024, 6), 2,',',' ') . ' ЭБ';
		}
		else if(abs($NumBytes/pow(1024, 5)) > 0.8)
		{
			return number_format($NumBytes/pow(1024, 5), 2,',',' ') . ' ПБ';
		}
		else if(abs($NumBytes/pow(1024, 4)) > 0.8)
		{
			return number_format($NumBytes/pow(1024, 4), 2,',',' ') . ' ТБ';
		}
		else if(abs($NumBytes/pow(1024, 3)) > 0.8)
		{
			return number_format($NumBytes/pow(1024, 3), 2,',',' ') . ' ГБ';
		}
		else if(abs($NumBytes/pow(1024, 2)) > 0.8)
		{
			return number_format($NumBytes/pow(1024, 2), 2,',',' ') . ' МБ';
		}
		else if(abs($NumBytes/1024) > 0.8)
		{
			return number_format($NumBytes/1024, 2,',',' ') . ' КБ';
		}
		else
		{
			return number_format($NumBytes, 0,',',' ') . ' Б';
		}
	}
?>