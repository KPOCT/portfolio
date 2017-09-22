<?php
	error_reporting( E_ERROR );
	
	function FillFooter(&$doc) // Заполняет подвал сайта, динамически подставляя переменные
	{
		$a = $doc->createElement('a');
		$a->setAttribute('href', 'http://'.$_SERVER['HTTP_HOST']);
		$a->nodeValue = $_SERVER['HTTP_HOST'];

		$small = $doc->createElement('small');
		$small->appendChild($doc->createTextNode('2017 © '));
		$small->appendChild($a);
		
		$p = $doc->createElement('p');
		$p->appendChild($small);

		$footer = $doc->getElementById('footer');
		$footer->appendChild($p);
	}

	function FillNav(&$doc) // Заполняет навигационное меню
	{
		$nav = $doc->getElementById('nav');

		$div = $doc->createElement('div');

		$a = $doc->createElement('a');
		$a->setAttribute('href', 'http://'.$_SERVER['HTTP_HOST'].'/kpoct');
		$a->nodeValue = 'Главная';
		$div->appendChild($a);

		$a = $doc->createElement('a');
		$a->setAttribute('href', '#');
		$a->nodeValue = 'О разработчике';
		$div->appendChild($a);

		$a = $doc->createElement('a');
		$a->setAttribute('href', '#');
		$a->nodeValue = 'Контакты';
		$div->appendChild($a);
		
		$nav->appendChild($div);
	}

	function FillHeader(&$doc)
	{
		$header = $doc->getElementById('header');

		$a = $doc->createElement('a');
		$a->setAttribute('href', 'http://'.$_SERVER['HTTP_HOST'].'/kpoct');
		$a->nodeValue = $_SERVER['HTTP_HOST'];

		$p = $doc->createElement('p');
		$p->nodeValue = "Сайт с задачами для факультатива";

		$header->appendChild($a);
		$header->appendChild($p);
	}

	function SetTitle(&$doc, $titleName)
	{
		$titles = $doc->getElementsByTagName('title');
		foreach ($titles as $title)
		{
			$title->nodeValue = $titleName;
		}
	}

	function PrintHTML($doc)
	{
		$htmls = $doc->getElementsByTagName('html');
		foreach ($htmls as $html)
		{
			echo innerHTML($html);
		}
	}

	function innerHTML($element)
	{
		$doc = new DOMDocument("1.0", "utf-8");
		$doc->appendChild($doc->importNode($element, TRUE));
		$html = trim($doc->saveHTML());
		$tag = $element->nodeName;
		return preg_replace('@^<' . $tag . '[^>]*>|</' . $tag . '>$@', '', $html);
	}

	function getElementsByClassName(&$doc, $className)
	{
		$nodes = array();

		$childNodes = $doc->getElementsByTagName('*');
		for ($i = 0; $i < $childNodes->length; $i++)
		{
			$temp = $childNodes->item($i);
			if (stripos($temp->getAttribute('class'), $className) !== false)
			{
				$nodes[] = $temp;
			}
		}

		return $nodes;
	}
	
	function createElement
	(
		$doc,
		$parent,
		$tag = 'div',
		$attributes = '',
		$value = ''
	)
	{
		$element = $doc->createElement($tag);
		$element->nodeValue = $value;
		foreach($attributes as $attribute => $value)
		{
			$element->setAttribute($attribute, $value);
		}
		$parent->appendChild($element);
		return $element;
	}

	function createElement2
	(
		$doc,
		$tag = 'div',
		$childes = NULL,
		$attributes = '',
		$value = '',
		$parent = NULL
	)
	{
		$element = $doc->createElement($tag);
		$element->nodeValue = $value;
		foreach($attributes as $attribute => $value)
		{
			$element->setAttribute($attribute, $value);
		}
		foreach($childes as $child)
		{
			$element->appendChild($child);
		}
		if($parent)
		{
			$parent->appendChild($element);
		}
		return $element;
	}
?>