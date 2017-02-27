
<?php 

//Using the themoviedb API to collect information for Now Playing Movies.   
$url = 'https://api.themoviedb.org/3/movie/now_playing?api_key=3a92fa1ff3261395ad9bd44c7cc95519&language=en-US&page=1&region=in';

    //Function to convert the data format
    function get_json_format($u)
    {
        $json = file_get_contents($u);
        $data = json_decode($json);
        return $data;
    }
    //Function to create hashtags for the Movie and Lead Actor, The hashtags will be used to search
    function create_hashtag($h)
    {
    $h = str_replace(' ', '', $h);
    $h = strtolower($h);
    $h = preg_replace("/:[[:alnum:]]*/","", $h);
    $h =  preg_replace("/[^A-Za-z0-9\-]/", "", $h);
    $h =  str_replace("-", "", $h);
    $h = "#".$h;
    return $h;
    }

    
	
    

$data = get_json_format($url);
$arr = $data->results;
$count_now_playing = count($data->results);
$title = array();
$over = array();
$poster = array();
$movie_file = fopen("movie_names.txt", "w+");

for ($x = 0; $x <$count_now_playing; $x++)
{
	
$title[$x] = $data->results[$x]->title;
$movie_id = $data->results[$x]->id;
echo "Movie Name --> ".$title[$x]."\n";
$credits_movie = "https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=3a92fa1ff3261395ad9bd44c7cc95519";
$credits_movie = str_replace("{movie_id}", $movie_id, $credits_movie);  
$json_cast = file_get_contents($credits_movie);
$cast = json_decode($json_cast);
$actor=$cast->cast[0]->name;
$actor = create_hashtag($actor);
$title[$x] = create_hashtag($title[$x]);
echo $title[$x]."\n".$actor;
$movie_name = $title[$x];
$title[$x] = $title[$x]."\n";
exec("Rscript words.r $movie_name $actor",$call_file);
print_r($call_file);

fwrite($movie_file, $title[$x]);


$over[$x]=$data->results[$x]->overview;

$poster[$x] = $data->results[$x]->poster_path;
}

//Ratings of the movies calculated
$rating_file =  file_get_contents("ratings.txt");
$s = "";
$movies_ratings = array();
for($i=0; $i<strlen($rating_file); $i++)
{   

    if(!is_numeric($rating_file[$i]) && $rating_file[$i] != '-')
    {   
        $s = (integer)$s;
        array_push($movies_ratings,$s);
        $s = "";
    }
    else
    {
        $s = $s.$rating_file[$i];
    }
}

rsort($movies_ratings);









?>


