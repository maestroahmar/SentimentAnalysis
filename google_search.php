<?php    
$url = 'https://api.themoviedb.org/3/movie/now_playing?api_key=3a92fa1ff3261395ad9bd44c7cc95519&language=english&page=1';




    $json = file_get_contents($url);
	
    
    $data = json_decode($json);
    $arr = $data->results;
    $count_now_playing = count($data->results);
    echo $count_now_playing;
    $title = array();
    $over = array();
    $poster = array();
    $movie_file = fopen("movie_names.txt", "w+");
    for ($x = 0; $x <$count_now_playing; $x++)
    {
    	
	 $title[$x] = $data->results[$x]->original_title;
	 
       echo $title[$x]."\n";
    $title[$x] = str_replace(' ', '', $title[$x]);
    $title[$x] = strtolower($title[$x]);
    $title[$x] = "#".$title[$x]."\n";
    $temp = $title[$x];
    exec("Rscript fine_twitter.r $temp",$call_file);
    print_r($call_file);
    fwrite($movie_file, $title[$x]);

	
	$over[$x]=$data->results[$x]->overview;

	$poster[$x] = $data->results[$x]->poster_path;
}
   


    
?>


