<?php
	define(OMEGA, 0.2);
?>

<?php
	$doc = new DOMDocument('5.0', 'utf-8'); // С помощью конструктора создаём объект doc, в который в следующей строке поместим DOM
	$doc->loadHTMLFile('../template.html'); // Считываем шаблон

	include '../template.php'; // Подключаем файл с функциями SetTitle(), Fill---(), ...
	
	SetTitle($doc, 'Задача №2'); // Изменяем значение тега <title>
	FillHeader($doc); // Заполняем <div id='header'>
	FillNav($doc); // Заполняем <div id='nav'>
	/**************************Заполнение основной части***************************/
	$main = $doc->getElementById('main'); // Основной контент, в который входит задание и решение
	/******************Задание*****************/
		$assignment = createElement( $doc, $main, 'div', array('id' => 'assignment') );
		
		$h3 = createElement( $doc, $assignment, 'h3', '', 'Задача №2' ); // Заголовок задания

		$assignment->appendChild($doc->createTextNode('Вычислить импенданс Z, если цепь имеет активное сопротивление R, ёмкость C и индуктивность L.'));
		$assignment->appendChild($doc->createElement('br'));
		$assignment->appendChild($doc->createTextNode('Известно, что ω = ' . OMEGA . '. Значения R, L, C ввести с клавиатуры.'));
		$assignment->appendChild($doc->createElement('br'));
		
		createElement
		(
			$doc,
			$assignment,
			'img',
			array
			(
				'src' => '/kpoct/images/latex.jpg',
				'alt' => 'Формула для расчетов',
				'title' => 'Формула для расчетов'
			)
		);
	/*******************************************/
	createElement( $doc, $main, 'hr' );
	/******************Решение*****************/
		$solve = createElement( $doc, $main, 'div', array( 'id' => 'solve' ) );

		$form = createElement
		(
			$doc,
			$solve,
			'form',
			array
			(
				'action' => '2.php',
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
				'class' => 'text-muted btn',
				'type' => 'number',
				'name' => 'inR',
				'step' => '0.000001',
				'required' => '',
				'placeholder' => 'Введите R'
			)
		);

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'class' => 'text-muted btn',
				'type' => 'number',
				'name' => 'inC',
				'step' => '0.000001',
				'required' => '',
				'placeholder' => 'Введите C'
			)
		);

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'class' => 'text-muted btn',
				'type' => 'number',
				'name' => 'inL',
				'step' => '0.000001',
				'required' => '',
				'placeholder' => 'Введите L'
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

		if( is_numeric($_POST['inR']) && is_numeric($_POST['inC']) && is_numeric($_POST['inL']) )
		{
			$result = createElement
			(
				$doc,
				$solve,
				'div',
				array
				(
					'id' => 'result',
					'class' => 'col-xs-6'
				)
			);

			createElement
			(
				$doc,
				$result,
				'div',
				array( 'class' => 'label alert-info center-block col-xs-4' ),
				'R = ' . $_POST['inR']
			);
			
			createElement
			(
				$doc,
				$result,
				'div',
				array( 'class' => 'label alert-info center-block col-xs-4' ),
				'C = ' . $_POST['inC'] 
			);
			
			createElement
			(
				$doc,
				$result,
				'div',
				array( 'class' => 'label alert-info center-block col-xs-4' ),
				'L = ' . $_POST['inL'] 
			);
			
			createElement
			(
				$doc,
				$result,
				'div',
				array( 'class' => 'label alert-success btn center-block col-xs-12' ),
				'Z = ' . calculate($_POST['inR'], $_POST['inC'], $_POST['inL'])
			);
		}
	/*******************************************/

/*******************************************************************************/
	FillFooter($doc); // Заполняем <div id='footer'>
	PrintHTML($doc); // Выводим обработаный HTML код
?>

<?php
	function calculate($R, $C, $L)
	{
		return sqrt
		(
			pow($R, 2)
			+
			pow
			(
				OMEGA * $L - 1 / (OMEGA * $C),
				2
			)
		);
	}
?>