<?php
	define(OMEGA, 0.2);
?>

<?php
	$doc = new DOMDocument('5.0', 'utf-8'); // С помощью конструктора создаём объект doc, в который в следующей строке поместим DOM
	$doc->loadHTMLFile('../template.html'); // Считываем шаблон

	include '../template.php'; // Подключаем файл с функциями SetTitle(), Fill---(), ...
	
	SetTitle($doc, 'Задача №3'); // Изменяем значение тега <title>
	FillHeader($doc); // Заполняем <div id='header'>
	FillNav($doc); // Заполняем <div id='nav'>
	/**************************Заполнение основной части***************************/
	$main = $doc->getElementById('main'); // Основной контент, в который входит задание и решение
	/******************Задание*****************/
		$assignment = createElement( $doc, $main, 'div', array('id' => 'assignment') );
		
		$h3 = createElement( $doc, $assignment, 'h3', '', 'Задача №3' ); // Заголовок задания

		$assignment->appendChild($doc->createTextNode('Что больше: квадрат суммы или сумма квадратов? Введите два числа и узнаете.'));
	/*******************************************/
	createElement( $doc, $main, 'hr' );
	/******************Решение*****************/
		$solve = createElement( $doc, $main, 'div', array( 'id' => 'solve' ) );

		$form =	createElement
		(
			$doc,
			$solve,
			'form',
			array
			(
				'action' => '3.php',
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
				'class' => 'btn',
				'type' => 'number',
				'name' => 'inNum1',
				'step' => '0.000001',
				'required' => '',
				'placeholder' => 'Первое число'
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
				'type' => 'number',
				'name' => 'inNum2',
				'step' => '0.000001',
				'required' => '',
				'placeholder' => 'Второе число'
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

		if( is_numeric($_POST['inNum1']) && is_numeric($_POST['inNum2']) )
		{
			$result = createElement( $doc, $solve, 'div', array( 'id' => 'result' ), 'Результат вычислений:' );
			createElement( $doc, $result, 'br' );
			createElement( $doc, $result, 'img', array( 'src' => 'http://latex.codecogs.com/gif.latex?(' . $_POST['inNum1'] . '+' . $_POST['inNum2'] . ')^2=' . pow($_POST['inNum1'] + $_POST['inNum2'], 2), 'title' => 'Формула квадрата суммы', 'alt' => 'Формула квадрата суммы') );
			createElement( $doc, $result, 'br' );
			createElement( $doc, $result, 'img', array( 'src' => 'http://latex.codecogs.com/gif.latex?' . $_POST['inNum1'] . '^2 +' . $_POST['inNum2'] . '^2 =' . (pow($_POST['inNum1'], 2) + pow($_POST['inNum2'], 2)), 'title' => 'Формула суммы квадратов', 'alt' => 'Формула суммы квадратов') );
			createElement( $doc, $result, 'br' );
			createElement( $doc, $result, 'img', array( 'src' => 'http://latex.codecogs.com/gif.latex?' . numcmp(pow($_POST['inNum1'] + $_POST['inNum2'], 2), pow($_POST['inNum1'], 2) + pow($_POST['inNum2'], 2)), 'title' => 'Формула сравнения', 'alt' => 'Формула сравнения') );
		}
	/*******************************************/

/*******************************************************************************/
	FillFooter($doc); // Заполняем <div id='footer'>
	PrintHTML($doc); // Выводим обработаный HTML код
?>

<?php
	function numcmp($num1, $num2)
	{
		return $num1 . ($num1 < $num2 ? '<' : ($num1 > $num2 ? '>' : '=')) . $num2;
	}
?>