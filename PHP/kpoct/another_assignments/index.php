<?php
	if(isset($_POST['page']))
	{
		switch($_POST['page'])
		{
			case 1:
			{
				header('Location: http://'.$_SERVER['HTTP_HOST'].'/kpoct/another_assignments/1.php');
				break;
			}
			case 2:
			{
				header('Location: http://'.$_SERVER['HTTP_HOST'].'/kpoct/another_assignments/2.php');
				break;
			}
			case 3:
			{
				header('Location: http://'.$_SERVER['HTTP_HOST'].'/kpoct/another_assignments/3.php');
				break;
			}
			case 4:
			{
				header('Location: http://'.$_SERVER['HTTP_HOST'].'/kpoct/another_assignments/5.php');
				break;
			}
			case 5:
			{
				header('Location: http://'.$_SERVER['HTTP_HOST'].'/kpoct/another_assignments/edit.php');
				break;
			}
			default: main();
		}
	}
	else
	{
		main();
	}
?>

<?php
	function main()
	{
		$doc = new DOMDocument("1.0", "utf-8"); // С помощью конструктора создаём объект doc, в который в следующей строке поместим DOM
		$doc->loadHTMLFile("../template.html"); // Считываем шаблон

		include '../template.php'; // Подключаем файл с функциями SetTitle(), Fill---(), ...

		SetTitle($doc, "Главная страница"); // Изменяем значение тега <title>
		FillHeader($doc); // Заполняем <div id='header'>
		FillNav($doc); // Заполняем <div id='nav'>
		/**************************Заполнение основной части***************************/
		$main = $doc->getElementById('main');
		
		$h3 = createElement( $doc, $main, 'h3', '', 'Главная страница' );

		$form = createElement
		(
			$doc,
			$main,
			'form',
			array
			(
				'action' => '',
				'method' => 'post',
				'id' => 'selecting_assignment'
			)
		);

		$optgroup = createElement
		(
			$doc,
			createElement
			(
				$doc,
				$form,
				'select',
				array
				(
					'name' => 'page',
					'class' => 'selectpicker',
					'data-style' => 'btn-default',
					'data-size' => 6,
					'title' => 'Выберите задачу'
				)
			),
			'optgroup',
			array
			(
				'label' => 'Выберите задачу'
			)
		);

		createElement
		(
			$doc,
			$optgroup,
			'option',
			array( 'value' => 1 ),
			'Задача №' . 1
		);

		createElement
		(
			$doc,
			$optgroup,
			'option',
			array( 'value' => 2 ),
			'Задача №' . 2
		);

		createElement
		(
			$doc,
			$optgroup,
			'option',
			array( 'value' => 3 ),
			'Задача №' . 3
		);

		createElement
		(
			$doc,
			$optgroup,
			'option',
			array( 'value' => 4 ),
			'Задача №' . 5
		);

		createElement
		(
			$doc,
			$optgroup,
			'option',
			array( 'value' => 5 ),
			'Редактор кода'
		);

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'type' => 'submit',
				'class' => 'btn btn-primary',
				'value' => 'OK'
			)
		);
		/*******************************************************************************/
		FillFooter($doc); // Заполняем <div id='footer'>
		PrintHTML($doc); // Выводим обработаный HTML код
	}
?>