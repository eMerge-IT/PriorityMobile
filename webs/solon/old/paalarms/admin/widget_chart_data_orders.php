<?php 
// SECURITY CHECK TO MAKE SURE THE CORRECT USERNAME AND PASSWORD HAS BEEN ENTERED
if(!$_COOKIE[user_name] | !$_COOKIE[user_pwd])
{
header("location: login.php");
exit;
}

require_once('../assets/widgets/mysql.class.php');
require_once('../assets/widgets/global.inc.php');
require_once('../assets/widgets/functions.inc.php');
include_once("../assets/widgets/charts/charts.php");

$year = $_GET[year];
$month = "01";
$count = 1; 

$chart [ 'chart_type' ] = "3d column";

$chart [ 'axis_value' ] = array (   'steps'            =>  "10",  
                                    'prefix'           =>  "", 
                                    'size'             =>  10); 
$chart [ 'axis_category' ] = array (   'size'          =>  10); 

$chart [ 'legend_label' ] = array (   'size'    =>  12); 

$chart [ 'legend_rect' ] = array (   'margin'          =>  5,
                                     'line_color'      =>  "f7941d",
                                     'line_alpha'      =>  100, 
                                     'line_thickness'  =>  0); 

$chart [ 'series_color' ] = array ( "f7941d", "666666", "99cc33"  );

$chart [ 'series_gap' ] = array (   'bar_gap'  =>  10); 


$chart [ 'chart_value' ] = array (  'prefix'         =>  "", 
                                    'suffix'         =>  "", 
                                    'decimals'       =>  0,
                                    'decimal_char'   =>  ".",  
                                    'separator'      =>  "",
                                    'position'       =>  "over",
                                    'hide_zero'      =>  false, 
                                    'as_percentage'  =>  false, 
                                    'font'           =>  "Arial", 
                                    'bold'           =>  true, 
                                    'size'           =>  12, 
                                    'color'          =>  "000000", 
                                    'alpha'          =>  90
                                  ); 

$chart[ 'draw' ] = array ( 
array ( 'type'=>"text", 'color'=>"000000", 'alpha'=>25, 'font'=>"arial", 'rotation'=>0, 'bold'=>true, 'size'=>20, 'x'=>360, 'y'=>430, 'width'=>100, 'height'=> 100, 'text'=>"".$year."", 'h_align'=>"left", 'v_align'=>"bottom" ), 
array ( 'type'=>"text", 'color'=>"000000", 'alpha'=>25, 'font'=>"arial", 'rotation'=>270, 'bold'=>true, 'size'=>20, 'x'=>0, 'y'=>300, 'width'=>200, 'height'=> 80, 'text'=>"Number of orders", 'h_align'=>"left", 'v_align'=>"middle" ) );

$chart [ 'chart_data' ][ 0 ][ 0 ] = "";
$chart [ 'chart_data' ][ 1 ][ 0 ] = "Orders";

		for ($count=1; $count<=12; $count++)
			{
				$orders			= 0;
				
				$query = mysql_query("select * from SHOP1_orders where date like '$year-$month%'");
				$numrows = mysql_num_rows($query);
								
				if ($numrows > 0)
					{
					
					while ($result = mysql_fetch_array($query))
						{
						// CHECK TO SEE IF ORDER HAS BEEN COMPLETED
						$dispatched = mysql_query("select * from SHOP1_order_status where order_id = '$result[id]' order by id desc limit 1");
						$dispatch = mysql_fetch_array($dispatched);
						if ($dispatch[action] == "Dispatched")
							{
							$orders++;
							}
						}						
					}
					
									
					
					$text_month = date("M", mktime(0, 0, 0, $month, 1, $year));
													
					
					$chart [ 'chart_data' ][ 0 ][ $count ] = "$text_month";
					$chart [ 'chart_data' ][ 1 ][ $count ] = "$orders";
					$orders			= 0;
					if ($month == "12")
						{
						$month = 01;
						}
					else
						{
						$month = $month+1;
						$str = strlen($month);
						if ($str == 1)
							{
							$month = "0".$month;
							}
						}					
					}


//send the new data to charts.swf
SendChartData($chart);



?>