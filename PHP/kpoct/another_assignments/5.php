<?php
	$doc = new DOMDocument('5.0', 'utf-8'); // С помощью конструктора создаём объект doc, в который в следующей строке поместим DOM
	$doc->loadHTMLFile('../template.html'); // Считываем шаблон

	include '../template.php'; // Подключаем файл с функциями SetTitle(), Fill---(), ...
	
	SetTitle($doc, 'Задача №5'); // Изменяем значение тега <title>
	FillHeader($doc); // Заполняем <div id='header'>
	FillNav($doc); // Заполняем <div id='nav'>
	/**************************Заполнение основной части***************************/
	$main = $doc->getElementById('main'); // Основной контент, в который входит задание и решение
	/******************Задание*****************/
		$assignment = createElement( $doc, $main, 'div', array('id' => 'assignment') );
		
		$h3 = createElement( $doc, $assignment, 'h3', '', 'Задача №5' ); // Заголовок задания

		$assignment->appendChild($doc->createTextNode('Определить по координатам точку на карте.'));
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
				'action' => '5.php',
				'method' => 'post'
			)
		); // Форма, в которую поместятся элементы input. <form action="5.php" method="post"> ... </form>

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'class' => 'btn',
				'type' => 'number',
				'name' => 'inLatitude',
				'min' => '-85',
				'max' => '85',
				'step' => '0.000001',
				'required' => '',
				'placeholder' => 'Широта'
			)
		);// <input type="number" name="inLatitude" ... placeholder="Широта">

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'class' => 'btn',
				'type' => 'number',
				'name' => 'inLongitude',
				'min' => '-180',
				'max' => '180',
				'step' => '0.000001',
				'required' => '',
				'placeholder' => 'Долгота'
			)
		);// <input type="number" name="inLatitude" ... placeholder="Долгота">

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
		);// <input type="submit" value="OK">

		if( is_numeric($_POST['inLatitude']) && is_numeric($_POST['inLongitude']) )
		{
			createElement
			(
				$doc,
				$solve,
				'div',
				array
				(
					'id' => 'map',
					'style' => 'width: 515px; height: 255px; float: left; margin-bottom: 10px;'
				)
			);

			createElement
			(
				$doc,
				$solve,
				'script',
				array
				(
					'src' => '//api-maps.yandex.ru/2.1/?lang=ru_RU',
					'type' => 'text/javascript'
				)
			);

			createElement
			(
				$doc,
				$solve,
				'script',
				'',
				'
					ymaps.ready(init);
					function init ()
					{
						// Параметры карты можно задать в конструкторе.
						var myMap = new ymaps.Map
						(
							// ID DOM-элемента, в который будет добавлена карта.
							"map",
							// Параметры карты.
							{
								// Географические координаты центра отображаемой карты.
								center: [' . $_POST['inLatitude'] . ', ' . $_POST['inLongitude'] . '],
								// Масштаб.
								zoom: 1,
								// Тип покрытия карты: "Спутник".
								type: "yandex#satellite",
								controls: ["zoomControl", "typeSelector"]
							}
						);

						myMap.geoObjects.add
						(
							new ymaps.Placemark
							(
								[' . $_POST['inLatitude'] . ', ' . $_POST['inLongitude'] . '],
								{
									balloonContent: "'. getHemispheres($_POST['inLatitude'], $_POST['inLongitude']) . '",
									iconCaption: "Click me",
									hintContent: "Ну же! Нажми на меня.."
								},
								{
									preset: "islands#greenDotIconWithCaption"
								}
							)
						);
					}
				'
			);
		}
	/*******************************************/
/*******************************************************************************/
	FillFooter($doc); // Заполняем <div id='footer'>
	PrintHTML($doc); // Выводим обработаный HTML код
?>

<?php
	function getHemispheres($lat, $lng)
	{
		return
			"Точка с координатами [$lat, $lng] "
			.
			(
				!$lat
				?
					(
						!$lng
						?
							"находится на стыке нулевого мередиана и экватора"
						:
							"принадлежит " . getEWHemisphere($lng) . " полушарию"
					)
				:
					(
						!$lng
						?
							"принадлежит " . getNSHemisphere($lat) . " полушарию"
						:
							"принадлежит " . getNSHemisphere($lat) . " и " . getEWHemisphere($lng) . " полушариям"
					)
			);
	}

	function getEWHemisphere($lng)
	{
		return $lng < 0 ? "западному" : "восточному";
	}
	
	function getNSHemisphere($lat)
	{
		return $lat < 0 ? "южному" : "северному";
	}
?>