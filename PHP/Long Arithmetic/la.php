<meta charset = 'utf-8'>
<pre>

<?php
	ini_set('display_errors', '1');

	$a = new LA( '9.01' ); // field1: '9'; field2: '1'; field3: '100'; field4: 'NULL'
	$b = new LA( '-000.0732000e2' );

	echo $a->ToString() . ' * ' . $a->ToString() . ' = ' . LAO::mul( $a, $a )->ToString() . PHP_EOL . PHP_EOL;
	echo $a->ToString() . ' * ' . $b->ToString() . ' = ' . LAO::mul( $a, $b )->ToString() . PHP_EOL . PHP_EOL;
	echo $b->ToString() . ' * ' . $a->ToString() . ' = ' . LAO::mul( $b, $a )->ToString() . PHP_EOL . PHP_EOL;
	echo $b->ToString() . ' * ' . $b->ToString() . ' = ' . LAO::mul( $b, $b )->ToString() . PHP_EOL . PHP_EOL;

	ini_set('display_errors', '0');
?>







<?php
	class LA // Long Arithmetic
	{
		// Class properties (class fields)
		// Свойства класса (поля класса)
		public $integer;
		public $decimal;
		public $decimal_digit;

		function __construct( $number )
		{
			// In the code below we create the "constructor overload"
			// В коде ниже мы создаём "перегрузку" конструктора
			if( is_string( $number ) )
			{
				if( !is_numeric( $number ) )
				{
					trigger_error( '"Неверно задано значение для класса ' . __CLASS__ . '. Ожидается число."', E_USER_ERROR );
					exit;
				}
			}
			else if( is_int( $number ) || is_float( $number ) )
			{
				trigger_error( '"Возможна потеря данных. Ожидается строка."', E_USER_WARNING );
				$number = (string)$number;
			}
			else
			{
				trigger_error( '"Неверно задано значение для класса ' . __CLASS__ . '. Ожидается строка."', E_USER_ERROR );
				exit;
			}

			$this->negative = NULL;

			if( is_negative( $number ) )
			{
				$this->negative = true;
			}
			$number = LAO::abs( $number );

			if( is_exp_number( $number ) )
			{
				$number = expToDecimal( $number );
			}
			else
			{
				$number = removeLeadingZeros( $number );
				$number = removeZerosAfterDot( $number );
			}

			// Define the class fields
			// Определяем поля класса
			$this->integer = getIntPart( $number );
			$this->decimal = getDecPart( $number );
			$this->decimal_digit = $this->decimal ? getDecDigit( $number ) : NULL;
		}

		function ToString( )
		{
			if( $this->integer === NULL )
			{
				trigger_error( '"Объект класса ' . __CLASS__ . ' не создан. Свойства отсутствуют. Возвращена пустая строка."', E_USER_WARNING );
			}
			return ( $this->negative && ( !!$this->integer || !!$this->decimal ) ? '-' : NULL ) . $this->integer . ( $this->decimal ? '.' : NULL ) . $this->decimal;
		}
	}
?>






<?php
	class LAO
	{
		public static function abs( $number )
		{
			if( is_int( $number ) || is_float( $number ) )
			{
				trigger_error( '"' . __METHOD__ . ': Возможна потеря данных. Ожидается строка."', E_USER_WARNING );
				$number = (string)$number;
			}
			else if ( is_object( $number ) )
			{
				if( get_class( $number ) == 'LA' )
				{
					$number = $number->ToString( );
					if( is_negative( $number ) || strpos( $number, '+' ) === 0 )
					{
						return new LA( substr( $number, 1 ) );
					}
					else
					{
						return new LA( $number );
					}
				}
			}

			if( is_string( $number ) )
			{
				if( is_negative( $number ) || strpos( $number, '+' ) === 0 )
				{
					return substr( $number, 1 );
				}
				else
				{
					return $number;
				}
			}
			else
			{
				trigger_error( '"Неверно задано значение для метода ' . __METHOD__ . '. Ожидается строка или объект класса LA."', E_USER_ERROR );
			}
		}

		public static function not( $number )
		{
			if( is_string( $number ) )
			{
				$number = new LA( $number );
			}

			if( is_int( $number ) || is_float( $number ) )
			{
				trigger_error( '"Возможна потеря данных. Ожидается строка. ' . __METHOD__ . '."', E_USER_WARNING );
				$number = (string)$number;
			}
			else if ( is_object( $number ) )
			{
				if( get_class( $number ) == 'LA' )
				{
					$number = $number->ToString( );
				}
			}

			if( is_string( $number ) )
			{
				$number = removeLeadingZeros( $number );
				$number = removeZerosAfterDot( $number );

				return ( $number == '0' ? true : false );
			}
			else
			{
				trigger_error( '"Неверно задано значение для метода ' . __METHOD__ . '. Ожидается строка или объект класса LA."', E_USER_ERROR );
			}
		}

		public static function eq( $one, $two )
		{
			// Перегрузка для первого параметра
			if( is_string( $one ) )
			{
				$one = new LA( $one );
			}
			if( is_int( $one ) || is_float( $one ) )
			{
				trigger_error( '"' . __METHOD__ . ' [параметр 1]: Возможна потеря данных. Ожидается строка."', E_USER_WARNING );
				$one = (string)$one;
			}
			else if ( is_object( $one ) )
			{
				if( get_class( $one ) == 'LA' )
				{
					$one = $one->ToString( );
				}
			}

			// Перегрузка для второго параметра
			if( is_string( $two ) )
			{
				$two = new LA( $two );
			}
			if( is_int( $two ) || is_float( $two ) )
			{
				trigger_error( '"' . __METHOD__ . ' [параметр 2]: Возможна потеря данных. Ожидается строка."', E_USER_WARNING );
				$two = (string)$two;
			}
			else if ( is_object( $two ) )
			{
				if( get_class( $two ) == 'LA' )
				{
					$two = $two->ToString( );
				}
			}

			if( is_string( $one ) )
			{
				if( is_string( $two ) )
				{
					$one = removeLeadingZeros( $one );
					$one = removeZerosAfterDot( $one );
					$two = removeLeadingZeros( $two );
					$two = removeZerosAfterDot( $two );

					return ( $one == $two ? true : false );
				}
				else
				{
					trigger_error( '"' . __METHOD__ . ' [параметр 2]: Неверно задано значение. Ожидается строка или объект класса LA."', E_USER_ERROR );
				}
			}
			else
			{
				trigger_error( '"' . __METHOD__ . ' [параметр 1]: Неверно задано значение. Ожидается строка или объект класса LA."', E_USER_ERROR );
			}
		}

		public static function ne( $one, $two )
		{
			// Перегрузка для первого параметра
			if( is_string( $one ) )
			{
				$one = new LA( $one );
			}
			if( is_int( $one ) || is_float( $one ) )
			{
				trigger_error( '"' . __METHOD__ . ' [параметр 1]: Возможна потеря данных. Ожидается строка."', E_USER_WARNING );
				$one = (string)$one;
			}
			else if ( is_object( $one ) )
			{
				if( get_class( $one ) == 'LA' )
				{
					$one = $one->ToString( );
				}
			}

			// Перегрузка для второго параметра
			if( is_string( $two ) )
			{
				$two = new LA( $two );
			}
			if( is_int( $two ) || is_float( $two ) )
			{
				trigger_error( '"' . __METHOD__ . ' [параметр 2]: Возможна потеря данных. Ожидается строка."', E_USER_WARNING );
				$two = (string)$two;
			}
			else if ( is_object( $two ) )
			{
				if( get_class( $two ) == 'LA' )
				{
					$two= $two->ToString( );
				}
			}

			if( is_string( $one ) )
			{
				if( is_string( $two ) )
				{
					$one = removeLeadingZeros( $one );
					$one = removeZerosAfterDot( $one );
					$two = removeLeadingZeros( $two );
					$two = removeZerosAfterDot( $two );

					return ( $one == $two ? false : true );
				}
				else
				{
					trigger_error( '"' . __METHOD__ . ' [параметр 2]: Неверно задано значение. Ожидается строка или объект класса LA."', E_USER_ERROR );
				}
			}
			else
			{
				trigger_error( '"' . __METHOD__ . ' [параметр 1]: Неверно задано значение. Ожидается строка или объект класса LA."', E_USER_ERROR );
			}

			// Или же можно просто: return !( LAO::eq( $one, $two ) ), но тогда при некорректных параметрах ошибка будет выводиться из метода LAO::eq, что может немного затруднить нахождение ошибки.
		}

		public static function gt( $objOne, $objTwo )
		{
			if ( is_object( $objOne ) )
			{
				if( !( get_class( $objOne ) == 'LA' ) )
				{
					$objOne = new LA( $objOne );
				}
			}
			else
			{
				$objOne = new LA( $objOne );
			}
			if ( is_object( $objTwo ) )
			{
				if( !( get_class( $objTwo ) == 'LA' ) )
				{
					$objTwo = new LA( $objTwo );
				}
			}
			else
			{
				$objTwo = new LA( $objTwo );
			}

			if( $objOne->negative )
			{
				if( !$objTwo->negative )
				{
					return false;
				}
			}
			else
			{
				if( $objTwo->negative )
				{
					return true;
				}
			}

			$aOne = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objOne->ToString( )
					 )
				)
			);
			$aTwo = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objTwo->ToString( )
					 )
				)
			);

			$min_key = getMinKey( array( $aOne, $aTwo ) );
			$max_key = getMaxKey( array( $aOne, $aTwo ) );
			for( $i = $max_key; $i >= $min_key; $i-- )
			{
				if( $aOne[ $i ] > $aTwo[ $i ] )
				{
					return true;
				}
				else if( $aTwo[ $i ] > $aOne[ $i ] )
				{
					return false;
				}
			}
			return false;
		}

		public static function lt( $objOne, $objTwo ) // less than
		{
			if ( is_object( $objOne ) )
			{
				if( !( get_class( $objOne ) == 'LA' ) )
				{
					$objOne = new LA( $objOne );
				}
			}
			else
			{
				$objOne = new LA( $objOne );
			}
			if ( is_object( $objTwo ) )
			{
				if( !( get_class( $objTwo ) == 'LA' ) )
				{
					$objTwo = new LA( $objTwo );
				}
			}
			else
			{
				$objTwo = new LA( $objTwo );
			}

			if( $objOne->negative )
			{
				if( !$objTwo->negative )
				{
					return false;
				}
			}
			else
			{
				if( $objTwo->negative )
				{
					return true;
				}
			}

			$aOne = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objOne->ToString( )
					 )
				)
			);
			$aTwo = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objTwo->ToString( )
					 )
				)
			);

			$min_key = getMinKey( array( $aOne, $aTwo ) );
			$max_key = getMaxKey( array( $aOne, $aTwo ) );
			for( $i = $max_key; $i >= $min_key; $i-- )
			{
				if( $aOne[ $i ] < $aTwo[ $i ] )
				{
					return true;
				}
				else if( $aTwo[ $i ] < $aOne[ $i ] )
				{
					return false;
				}
			}
			return false;
		}

		public static function le( $objOne, $objTwo ) // less than or equal
		{
			return LAO::eq( $objOne, $objTwo ) || LAO::lt( $objOne, $objTwo );
		}

		public static function ge( $objOne, $objTwo ) // greater than or equal
		{
			return LAO::eq( $objOne, $objTwo ) || LAO::lg( $objOne, $objTwo );
		}

		public static function sum( $objOne, $objTwo )
		{
			if ( is_object( $objOne ) )
			{
				if( !( get_class( $objOne ) == 'LA' ) )
				{
					$objOne = new LA( $objOne );
				}
			}
			else
			{
				$objOne = new LA( $objOne );
			}
			if ( is_object( $objTwo ) )
			{
				if( !( get_class( $objTwo ) == 'LA' ) )
				{
					$objTwo = new LA( $objTwo );
				}
			}
			else
			{
				$objTwo = new LA( $objTwo );
			}

			if( $objOne->negative )
			{
				if( !$objTwo->negative )
				{
					return LAO::sub( $objTwo, LAO::abs( $objOne ) );
				}
			}
			else
			{
				if( $objTwo->negative )
				{
					return LAO::sub( $objOne, LAO::abs( $objTwo ) );
				}
			}

			$aOne = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objOne->ToString( )
					 )
				)
			);
			$aTwo = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objTwo->ToString( )
					 )
				)
			);

			$inc_next_digit = false;
			$min_key = getMinKey( array( $aOne, $aTwo ) );
			$max_key = getMaxKey( array( $aOne, $aTwo ) );
			for( $i = $min_key; $i <= $max_key + 1; $i++ )
			{
				if( !$i )
				{
					$aThree[ $i ] = '.';
					continue;
				}
				$sum_chars = $inc_next_digit + ( isset( $aOne[ $i ] ) ? $aOne[ $i ] : NULL ) + ( isset( $aTwo[ $i ] ) ? $aTwo[ $i ] : NULL );
				$inc_next_digit = false;
				if( $sum_chars >= 10 )
				{
					$sum_chars -= 10;
					$inc_next_digit = true;
				}
				$aThree[ $i ] = $sum_chars;
			}

			$return_object = new LA( implode( NULL, array_reverse( $aThree ) ) );
			$return_object->negative = ( $objOne->negative && $objTwo->negative ) ? true : NULL;
			return $return_object;
		}

		public static function sub( $objOne, $objTwo )
		{
			if ( is_object( $objOne ) )
			{
				if( !( get_class( $objOne ) == 'LA' ) )
				{
					$objOne = new LA( $objOne );
				}
			}
			else
			{
				$objOne = new LA( $objOne );
			}
			if ( is_object( $objTwo ) )
			{
				if( !( get_class( $objTwo ) == 'LA' ) )
				{
					$objTwo = new LA( $objTwo );
				}
			}
			else
			{
				$objTwo = new LA( $objTwo );
			}

			if( $objOne->negative )
			{
				if( !$objTwo->negative )
				{
					$return_object = LAO::sum( LAO::abs( $objOne ), $objTwo );
					$return_object->negative = true;
					return $return_object;
				}
				else
				{
					return LAO::sub( LAO::abs( $objTwo ), $objOne );
				}
			}
			else
			{
				if( $objTwo->negative )
				{
					return LAO::sum( $objOne, LAO::abs( $objTwo ) );
				}
			}

			if( $objTwo > $objOne )
			{
				$return_object = LAO::sub( LAO::abs( $objTwo ), LAO::abs( $objOne ) );
				$return_object->negative = true;
				return $return_object;
			}

			$aOne = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objOne->ToString( )
					 )
				)
			);
			$aTwo = alignByDot
			(
				str_split
				(
					 LAO::abs
					 (
						 $objTwo->ToString( )
					 )
				)
			);

			$dec_next_digit = false;
			$min_key = getMinKey( array( $aOne, $aTwo ) );
			$max_key = getMaxKey( array( $aOne, $aTwo ) );
			for( $i = $min_key; $i <= $max_key + 1; $i++ )
			{
				if( !$i )
				{
					$aThree[ $i ] = '.';
					continue;
				}
				$sub_chars = ( isset( $aOne[ $i ] ) ? $aOne[ $i ] : NULL ) - $dec_next_digit - ( isset( $aTwo[ $i ] ) ? $aTwo[ $i ] : NULL );
				$dec_next_digit = false;
				if( $sub_chars < 0 )
				{
					$sub_chars += 10;
					$dec_next_digit = true;
				}
				$aThree[ $i ] = $sub_chars;
			}
			
			return new LA( implode( NULL, array_reverse( $aThree ) ) );
		}

		public static function inc( $number, $digit = '0' )
		{
			if( is_negative( $digit ) )
			{
				$digit = LAO::abs( $digit );
				$inc_number = shiftNumberToRight( '1', $digit );
			}
			else
			{
				$inc_number = shiftNumberToLeft( '1', $digit );
			}
			return LAO::sum( $number, $inc_number);
		}

		public static function dec( &$number, $digit = '0' )
		{
			if( is_negative( $digit ) )
			{
				$digit = LAO::abs( $digit );
				$inc_number = shiftNumberToRight( '1', $digit );
			}
			else
			{
				$inc_number = shiftNumberToLeft( '1', $digit );
			}
			$number = LAO::sub( $number, $inc_number);
			return $number;
		}

		public static function mul( $objOne, $objTwo )
		{
			if ( is_object( $objOne ) )
			{
				if( !( get_class( $objOne ) == 'LA' ) )
				{
					$objOne = new LA( $objOne );
				}
			}
			else
			{
				$objOne = new LA( $objOne );
			}
			if ( is_object( $objTwo ) )
			{
				if( !( get_class( $objTwo ) == 'LA' ) )
				{
					$objTwo = new LA( $objTwo );
				}
			}
			else
			{
				$objTwo = new LA( $objTwo );
			}

			if( $objOne->negative ) // Первое число - отрицательное
			{
				if( !$objTwo->negative ) // Первое число со знаком '-', второе - со знаком '+'
				{
					$return_object = LAO::mul( LAO::abs( $objOne ), $objTwo );
					$return_object->negative = true;
					return $return_object;
				}
				else // - -
				{
					return LAO::mul( LAO::abs( $objOne ), LAO::abs( $objTwo ) );
				}
			}
			else
			{
				if( $objTwo->negative ) // + -
				{
					$return_object = LAO::mul( $objOne, LAO::abs( $objTwo ) );
					$return_object->negative = true;
					return $return_object;
				}
			}

			if( $objOne > $objTwo )
			{
				return LAO::mul( $objTwo, $objOne );
			}

			if( $objOne->decimal || $objTwo->decimal )
			{
				$digits = strlen( $objOne->decimal ) + strlen( $objTwo->decimal );
				return new LA
				(
					shiftNumberToRight
					(
						LAO::mul
						(
							new LA( $objOne->integer . $objOne->decimal ),
							new LA( $objTwo->integer . $objTwo->decimal )
						)->ToString(),
						$digits
					)
				);
			}

			$return_object = new LA( '0' );
			for( $i = $objOne; LAO::gt( $i, '0' ); LAO::dec( $i ) )
			{
				$return_object = LAO::sum( $return_object, $objTwo );
			}
			return $return_object;
		}
	}
?>



<?php
	function getMaxKey( $aArrays )
	{
		$max = 1;
		foreach( $aArrays as $array )
		{
			foreach( $array as $key => $char )
			{
				$max = ( $key > $max ? $key : $max );
			}
		}
		return $max;
	}

	function getMinKey( $aArrays )
	{
		$min = 1;
		foreach( $aArrays as $array )
		{
			foreach( $array as $key => $char )
			{
				$min = ( $key < $min ? $key : $min );
			}
		}
		return $min;
	}

	function alignByDot( $aNumber )
	{
		$dot_position = getDotPosition( implode( NULL, $aNumber ) );
		$dot_position = $dot_position === false ? strlen( implode( NULL, $aNumber ) ) : $dot_position;

		foreach( $aNumber as $key => $char )
		{
			$return_array[ $dot_position - $key ] = $char;
		}

		return $return_array;
	}
1 2 3 . 4 5 6 7
0 1 2 3 4 5 6 7

1 2 3 .  4  5  6  7
3 2 1 0 -1 -2 -3 -4


	function is_exp_number( $number )
	{
		if( is_numeric( $number ) && containi( $number, 'e' ) )
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	function getIntPart( $number )
	{
		return getStrBeforeStr( $number, '.' );
	}

	function getDecPart( $number )
	{
		return getStrAfterStr( $number, '.' );
	}

	function getDecDigit( $number )
	{
		return shiftNumberToLeft( '1', strlen( getDecPart( $number) ) );
	}

	function getShiftNumber( $number )
	{
		return getStrBeforeStri( $number, 'e' );
	}

	function getShiftDigit( $number )
	{
		return getStrAfterStri( $number, 'e' );
	}

	function expToDecimal( $number )
	{
		if( !is_numeric( $number ) || !containi( $number, 'e' ) )
		{
			return false;
		}

		$minus = NULL;

		if( is_negative( $number ) )
		{
			$number = LAO::abs( $number );
			$minus = '-';
		}

		// Под вопросом название переменной. Сдвигаемое число?! Переменная хранит в себе число в []: [1.0]Е+5
		$shift_number = getShiftNumber( $number );
		// Под вопросом название переменной. Разряд сдвига?! Переменная хранит в себе число в []: [1.0]Е+5
		$shift_digit = getShiftDigit( $number );

		if( !LAO::abs( $shift_digit ) )
		{
			$shift_number = removeLeadingZeros( $shift_number );
			$shift_number = removeZerosAfterDot( $shift_number );
			return $shift_number;
		}

		if( is_negative( $shift_digit ) )
		{
			$shift_digit = LAO::abs( $shift_digit );
			return $minus . shiftNumberToRight( $shift_number, $shift_digit );
		}
		else
		{
			return $minus . shiftNumberToLeft( $shift_number, $shift_digit );
		}
	}

	function shiftNumberToRight( $number, $digit )
	{
		$number = removeLeadingZeros( $number );

		$number_without_dot = str_replace( '.', '', $number );

		$old_dot_position = getDotPosition( $number );
		if( $old_dot_position === false )
		{
			$old_dot_position = strlen( $number );
		}

		$zeros = NULL;
		$new_dot_position = $old_dot_position - $digit;
		if( $new_dot_position < 1 )
		{
			for( $i = $new_dot_position; $i < 0; $i++ )
			{
				$zeros .= '0';
			}
			$new_dot_position -= leadingZerosCount( $number_without_dot );
			$return_number = removeLeadingZeros( $number_without_dot );
			$return_number = pasteStrToStr( $return_number, '0.' . $zeros, 0 );
			$return_number = removeZerosAfterDot( $return_number );
			return $return_number;
		}

		$new_dot_position -= leadingZerosCount( $number_without_dot );
		$return_number = removeLeadingZeros( $number_without_dot );
		$return_number = pasteStrToStr( $return_number, '.', $new_dot_position );
		$return_number = removeZerosAfterDot( $return_number );
		return $return_number;
	}

	function shiftNumberToLeft( $number, $digit )
	{
		$number_without_dot = str_replace( '.', '', $number );

		$old_dot_position = getDotPosition( $number );
		if( $old_dot_position === false )
		{
			$old_dot_position = strlen( $number );
		}

		$zeros = NULL;
		$new_dot_position = $old_dot_position + $digit;
		if( $new_dot_position > strlen( $number_without_dot ) )
		{
			for( $i = ( $new_dot_position - $old_dot_position ); $i > 0; $i-- )
			{
				$zeros .= '0';
			}
		}
		$return_number = pasteStrToStr( $number_without_dot, $zeros, strlen( $number_without_dot ) ); // Вставляем ноли справа ( 00123 -> 001230000)

		$new_dot_position -= leadingZerosCount( $return_number );

		$return_number = removeLeadingZeros( $return_number ); // Удаляем ведущие ноли (001230000 -> 1230000)

		while( $new_dot_position <= 0 )
		{
			$return_number = pasteStrToStr( $return_number, '0', 0);
			$new_dot_position++;
		}

		$return_number = pasteStrToStr( $return_number, '.', $new_dot_position ); // Вставляем точку (1230000 -> 123.0000)

		$return_number = removeZerosAfterDot( $return_number ); // Удаляем ноли после точки и точку, если они последняя в строке (123.0000 -> 123)

		return $return_number;
	}

	function removeLeadingZeros( $number )
	{
		while( $number[0] === '0' && ( isset( $number[1] ) ? $number[1] : NULL ) !== '.' )
		{
			$number = substr( $number, 1);
		}
		return ( $number === false ? '0' : $number );
	}

	function leadingZerosCount( $number )
	{
		$i = 0;
		$sum = 0;
		while( $number[$i] === '0' || $number[$i] === '.' )
		{
			if( $number[$i] === '.' )
			{
				continue;
			}
			$sum++;
			$i++;
		}
		return $sum;
	}

	function removeZerosAfterDot( $number )
	{
		while( substr( $number, -1 ) === '0' || substr( $number, -1 ) === '.' )
		{
			if( substr( $number, -1 ) === '.' )
			{
				return $number = substr( $number, 0, -1 );
			}

			if( getDotPosition( $number ) !== false )
			{
				$number = substr( $number, 0, -1 );
			}
			else
			{
				return $number;
			}
		}

		$number = $number === '' ? '0' : $number;
		return $number;
	}

	function pasteStrToStr( $train, $railcar, $position)
	{
		if( $position < 0 || $position > strlen( $train ) )
		{
			return false;
		}
		else
		{
			return substr( $train, 0, $position ) . $railcar . substr( $train, $position );
		}
	}

	function getDotPosition( $number )
	{
		return strpos( $number, '.' );
	}

	function is_negative( $number )
	{
		return ( substr( strval( $number ), 0, 1 ) == '-' );
	}
	
	function contain( $haystack, $needle )
	{
		return ( strpos( $haystack, $needle ) !== false ) ? true : false;
	}

	function containi( $haystack, $needle )
	{
		return ( stripos( $haystack, $needle ) !== false ) ? true : false;
	}

	function getStrBeforeStr( $str, $wall )
	{
		$wall_position = strpos( $str, $wall );
		return ( $wall_position !== false ) ? substr( $str, 0, $wall_position ) : $str;
	}

	function getStrAfterStr( $str, $wall )
	{
		$wall_position = strpos( $str, $wall );
		return ( $wall_position !== false ) ? substr( $str, $wall_position + 1 ) : NULL;
	}

	function getStrBeforeStri( $str, $wall )
	{
		$wall_position = stripos( $str, $wall );
		return ( $wall_position !== false ) ? substr( $str, 0, $wall_position ) : $str;
	}

	function getStrAfterStri( $str, $wall )
	{
		$wall_position = stripos( $str, $wall );
		return ( $wall_position !== false ) ? substr( $str, $wall_position + 1 ) : NULL;
	}
?>