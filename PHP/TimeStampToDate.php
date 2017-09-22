<?php

    /*
     * Добавить спецификаторы.
     * Перевести под перечисления.
     * Написать обратную ф-ю.
     */

    $timestamp = time()+300000;
    echo $timestamp . " = " . TimeStampToDate( $timestamp ) . " = " . date("d.m.Y H:i:s", $timestamp);
    
    function TimeStampToDate( $timestamp )
    {
        $result = array
        (
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL
        );

        $array = array
        (
            31536000,
            array
            (
                2678400,
                2419200,
                2678400,
                2592000,
                2678400,
                2592000,
                2678400,
                2678400,
                2592000,
                2678400,
                2592000,
                2678400
            ),
            86400,
            3600,
            60,
            1
        );

        for( $i = 0; $i < count( $array ); $i++ )
        {
            if( is_array( $array[ $i ] ) )
            {
                for( $j = 0; $j < 12; $j++ )
                {
                    $result[ $i ]++;
                    $timestamp -= $array[ $i ][ $j ];
                    if( $timestamp < 0 )
                    {
                        $timestamp += $array[ $i ][ $j ];
                        break;
                    }
                }
                $timestamp -= ( (int)( ( $result[ 0 ] ) / 4 ) * 86400 );
            }
            else
            {
                $result[ $i ] = (int)( $timestamp / $array[ $i ] );
                $timestamp %= $array[ $i ];
            }
        }

        $years = $result[ 0 ];
        $months = $result[ 1 ];
        $days = $result[ 2 ];
        $hours = $result[ 3 ];
        $minutes = $result[ 4 ];
        $seconds = $result[ 5 ];

        sprintf
        (
            "%2d.%2d.%4d %2d:%2d:%2d",
            ( $days ? $days : "01" ),
            ( $months ? $months : "01" ),
            ( $years + 1970 ),
            ( $hours + 3 ),
            $minutes,
            $seconds
        );
    }
?>
