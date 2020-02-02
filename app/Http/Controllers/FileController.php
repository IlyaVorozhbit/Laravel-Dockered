<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FileController extends Controller
{
    public function create(Request $request)
    {
        $data = $request->all();

        for ($row = 0; $row < $data['rows']; $row++) {
            for ($led_number = 0; $led_number < $data['leds_in_row']; $led_number++) {
                $t = $this->physicalLedNumber($led_number, $row, $data['leds_in_row']);

                echo "[LED: $led_number, ROW: $row]\n";
                echo "{{$t}}\n";
            }

            echo '<br/>';
        }
    }

    function physicalLedNumber($led, $row, $leds_in_row)
    {
        return $led + $leds_in_row * $row;
    }
}
