<?php
	session_start();

	$g_lastID = -1;			// Глобалка для функции getFilePathByID, которая служит идентификатором для последнего обработанного в функции файла.
	$g_selected_file = '';	// Глобалка, содержащая путь к выбранному пользователем файлу.
							// Можно обойтись без использования этих переменных, но я остановился пока что на этом варианте: еще не факт, что
							// избавление от них и использование более 'навороченного' алгоритма будет оптимальнее.
?>

<?php
	if( isset($_POST['item_id']) )
	{
		getFilePathByID
		(
			$_SERVER['DOCUMENT_ROOT'].'/kpoct',
			$_POST['item_id']
		);

		if( $_SESSION['s_selected_file'] )
		{
			echo file_get_contents( $_SESSION['s_selected_file'] );
		}
		exit();
	}
?>

<?php
	$doc = new DOMDocument('5.0', 'utf-8'); // С помощью конструктора создаём объект doc, в который в следующей строке поместим DOM
	$doc->loadHTMLFile('../template.html'); // Считываем шаблон

	include '../template.php'; // Подключаем файл с функциями SetTitle(), Fill---(), ...
	
	SetTitle($doc, 'Редактор кода'); // Изменяем значение тега <title>
	FillHeader($doc); // Заполняем <div id='header'>
	FillNav($doc); // Заполняем <div id='nav'>
/**************************Заполнение основной части***************************/
	$main = $doc->getElementById('main'); // Основной контент

	if( isset($_POST['auth_key']) )
	{
		if( $_POST['auth_key'] == 'zzhothqi' )
		{
			$_SESSION['authorized'] = true;
		}
		else
		{
			$_SESSION['authorized'] = false;

			createElement
			(
				$doc,
				createElement
				(
					$doc,
					$main,
					'h4'
				),
				'span',
				array( 'class' => 'label label-danger' ),
				'Вы ввели недействительный ключ'
			) ; // Выводим ошибку при неудаче
		}
	}

	if( !$_SESSION['authorized'] )
	{
		createElement
		(
			$doc,
			$main,
			'h3',
			NULL,
			'Введите ключ, чтобы получить доступ к этой странице'
		);

		$form = createElement
		(
			$doc,
			$main,
			'form',
			array
			(
				'method' => 'post'
			)
		);

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'type' => 'password',
				'class' => 'input btn',
				'placeholder' => 'Введите ключ авторизации',
				'name' => 'auth_key',
				'required' => ''
			)
		);

		createElement
		(
			$doc,
			$form,
			'input',
			array
			(
				'type' => 'submit',
				'class' => 'input btn',
				'value' => 'OK'
			)
		);

		FillFooter($doc); // Заполняем <div id='footer'>
		PrintHTML($doc); // Выводим обработаный HTML код

		exit();
	} // if( !$_SESSION['authorized'] )

	createElement
	(
		$doc,
		$main,
		'h3',
		NULL,
		'Редактор кода'
	); // Заголовок

	createElement
	(
		$doc,
		createElement
		(
			$doc,
			$main,
			'div',
			array
			(
				'id' => 'treeview',
				'class' => 'treeview col-xs-5 col-sm-5 col-md-5 col-lg-5'
			)
		),
		'script',
		NULL,
		'
			$(
				function()
				{
					$("#treeview").treeview
					(
						{
							expandIcon: "glyphicon glyphicon-folder-close",
							collapseIcon: "glyphicon glyphicon-folder-open",
							nodeIcon: "glyphicon glyphicon-file",
							showBorder: true,
							showTags: true,
							color: "#ccc",
							backColor: "#333",
							onhoverColor: "#777",
							borderColor: "white",
							selectedColor: "white",
							selectedBackColor: "#111",
							data: ' . PHP_EOL . fillTreeObjectsArray( $_SERVER['DOCUMENT_ROOT'].'/kpoct', 8 ) . '
						}
					);
					$("#treeview").treeview("collapseAll");
				}
			);
		'
	);

	$div_code = createElement
	(
		$doc,
		$main,
		'div',
		array( 'class' => 'CodeMirrorDiv col-xs-12 col-sm-12 col-md-12 col-lg-12' )
	);

	createElement
	(
		$doc,
		$div_code,
		'textarea',
		array( 'id' => 'code' )
	);

	createElement
	(
		$doc,
		$div_code,
		'script',
		NULL,
		'
			var codeEditor = CodeMirror.fromTextArea
			(
				document.getElementById("code"),
				{
					lineNumbers: true,
					matchBrackets: true,
					mode: "application/x-httpd-php",
					indentUnit: 4,
					indentWithTabs: true,
					enterMode: "keep",
					tabMode: "shift"
				}
			);
			codeEditor.setOption("theme", "monokai");
			$(".CodeMirror").resizable
			({
				resize: function()
				{
					codeEditor.setSize
					(
						$(this).width(),
						$(this).height()
					);
				}
			});
		' .
		(
			$_SESSION['s_selected_file']
			?
			(
				substr($_SESSION['s_selected_file'], -2) == 'js'
				?
					'codeEditor.setOption("mode", "javascript");'
				:
				(
					substr($_SESSION['s_selected_file'], -3) == 'css'
					?
						'codeEditor.setOption("mode", "css");'
					:
					(
						substr($_SESSION['s_selected_file'], -3) == 'php'
						?
							'codeEditor.setOption("mode", "php");'
						:
						(
							substr($_SESSION['s_selected_file'], -4) == 'html' || substr($_SESSION['s_selected_file'], -4) == 'htm' || substr($_SESSION['s_selected_file'], -4) == 'xml'
							?
								'codeEditor.setOption("mode", "xml");'
							:
								''
						)
					)
				)
			)
			:
				''
		)
	);

	createElement
	(
		$doc,
		$div_code,
		'button',
		array
		(
			'class' => 'btn btn-default',
			'type' => 'button',
			'title' => 'undo',
			'onClick' => 'codeEditor.execCommand("undo");'
		),
		'undo'
	);

	createElement
	(
		$doc,
		$div_code,
		'button',
		array
		(
			'class' => 'btn btn-default',
			'type' => 'button',
			'title' => 'save',
			'onClick' => ''
		),
		'save'
	);
/*******************************************************************************/
	FillFooter($doc); // Заполняем <div id='footer'>
	PrintHTML($doc); // Выводим обработаный HTML код

	function fillTreeObjectsArray( $folder, $indent )
	{
		$files = scandir($folder);

		$returnString = set_indent( $indent ) . '[' . PHP_EOL;

		$remain_files_amount = get_files_amount( $folder );

		foreach($files as $file)
		{
			if( ($file == '.') || ($file == '..') )
			{
				continue;
			}

			--$remain_files_amount;

			$f0 = $folder.'/'.$file;

			$returnString .=
				set_indent( $indent + 1 ) . '{' . PHP_EOL .
				set_indent( $indent + 2 ) . 'text: "' . $file . '",' . PHP_EOL;

			if(is_dir($f0))
			{
				$returnString .=
					set_indent( $indent + 2 ) . 'tags: ["'. get_files_amount($f0) . '"],' . PHP_EOL .
					set_indent( $indent + 2 ) . 'nodes:' . PHP_EOL . fillTreeObjectsArray( $f0, $indent + 2 );
			}
			else
			{
				$returnString .= set_indent( $indent + 2 ) . 'href: "#"';
			}

			$returnString .= PHP_EOL .
				set_indent( $indent + 1 ) . '}' . ($remain_files_amount ? ',' : '') . PHP_EOL;
		}

		return $returnString .= set_indent( $indent ) . ']';
	}

	function getFilePathByID( $folder, $ID)
	{
		$files = scandir($folder);

		foreach($files as $file)
		{
			if( ($file == '.') || ($file == '..') )
			{
				continue;
			}

			$f0 = $folder.'/'.$file;

			++$GLOBALS['g_lastID'];

			if( $GLOBALS['g_lastID'] == $ID )
			{
				if( is_dir($f0) )
				{
					$_SESSION['s_selected_file'] = NULL;
					return NULL;
				}
				else
				{
					$_SESSION['s_selected_file'] = $f0;
					return NULL;
				}
			}
			else
			{
				if( is_dir($f0) )
				{
					getFilePathByID( $f0, $ID );
				}
			}
		}
		return NULL;
	}

	function get_files_amount( $folder )
	{
		$files = scandir($folder);

		$count = 0;

		foreach($files as $file)
		{
			if( ($file == '.') || ($file == '..') )
			{
				continue;
			}
			$count++;
		}
		
		return $count;
	}

	function set_indent( $indent_amount )
	{
		$returnString = '';

		for( $i = 0; $i < $indent_amount; $i++)
		{
			$returnString .= '	';
		}

		return $returnString;
	}
?>