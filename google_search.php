
<?php 

//Using the themoviedb API to collect information for Now Playing Movies.   
$url = 'https://api.themoviedb.org/3/movie/now_playing?api_key=3a92fa1ff3261395ad9bd44c7cc95519&language=en-US&page=1&region=in';

    //Function to convert the data format in JSON
    function get_json_format($u)
    {
        $json = file_get_contents($u);          //Getting the HTML contents of the webpage.
        $data = json_decode($json);             //The HTML content is converted into JSON format which is easy to comprehend. 
        return $data;
    }
    //Function to create hashtags for the Movie and Lead Actor, The hashtags will be used to search
    function create_hashtag($h)
    {
    $h = str_replace(' ', '', $h);      //removing the unwanted spaces from the movie name
    $h = strtolower($h);
    //lower case conversion  to provide ease in searching for the movie via R. Twitter Search via R is case sensitive.
    $h = preg_replace("/:[[:alnum:]]*/","", $h);
    //removing the unwanted tagline of the movie that is mined from the DB. This will result in the shortening of the name, this is known as Tokenization.The asterix here denotes the use of Regular Expressions which find any sequence that is alpha numeric.

    $h =  preg_replace("/[^A-Za-z0-9\-]/", "", $h);
    //Any wanted keyword that starts will be replaced
    $h =  str_replace("-", "", $h);
    //Replacing unwanted hyphen.
    $h = "#".$h;
    //concatinating # before the movie to make the search word more existing and is easy to find.
    return $h;
    } 

    
    
    
$db_rate =array();
$data = get_json_format($url);
//user-defined function call  to get JSON format ready
$arr = $data->results;
// accessing the results that are produced using referential structure.
$count_now_playing = count($data->results);         //count the number of upcoming movies by counting the distinct number of movies that are present in DB.

$title = array();
//Intializing an array that is used to store the names of the movies.
$over = array();
//Intializing an array that is used to store the overview/small description of the movies.The description will be shown the main home page of site.
$poster = array();
//Intializing an array that is used to store the url of the poster of movies, the posters are provided as web .jpg format and can be downloaded. It will be displayed in the div property of the site.
#$movie_file = fopen("movie_names.txt", "w+");
$movie_poster = fopen('movie_poster.txt', 'a+');
#$movie_name = fopen("movies.txt","w+");
//Opening a new file/existing file which will contain the names of all the movies that  are being named from the Movie DB.

$orig_poster = array();
$fp=fopen('movies_list.csv', 'w+');
for ($x = 0; $x <10; $x++)
    //Iterating with the number of the JSON objects as the names of the movies.
{

$title[$x] = $data->results[$x]->title;
$orig_title = $title[$x];
//Extracting/Mining the title of the movie JSON object from the returned object. 
$movie_id = $data->results[$x]->id;

$movie_rate_db = $data->results[$x]->vote_average;
array_push($db_rate, $movie_rate_db);
//Extracting/Mining the title of the movie JSON object from the returned object. The movie ID is unique, which is used further to call API to extract more data about the movie.
echo "Movie Name --> ".$title[$x]."\n  Movie ID ---->".$movie_id."\n"."Movie Rating by DB ".$movie_rate_db."\n";
//Debugging purposes console output.
$credits_movie = "https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=3a92fa1ff3261395ad9bd44c7cc95519";
//new url for calling a new API with different data.q
$credits_movie = str_replace("{movie_id}", $movie_id, $credits_movie); 
//Replacing the general/generic url with the movie Id, dynamically every time the loop iterates. 
$json_cast = file_get_contents($credits_movie);
//user-defined function call  to get JSON format ready. This API call is reponsible for getting the information associated with the movie such as Protogonist, Music Director.
$cast = json_decode($json_cast);
//The HTML content is converted into JSON format which is easy to comprehend. 
$actor=$cast->cast[0]->name;
//The 'cast' JSON object array contains the names of actors who played their part in the movie.
$actor = create_hashtag($actor);
//calling the user defined method to get the name of the actor in a format so that they get hashtags names.
#fwrite($movie_name, $title[$x]);
$title[$x] = create_hashtag($title[$x]);

fputcsv($fp,explode(',',$title[$x]." "));

//calling the user defined method to get the name of the movie in a format so that they get hashtags names.
echo $title[$x]."\n".$actor;
//Debugging purposes console output.
$movie_name = $title[$x];
$title[$x] = $title[$x]."\n";
#fwrite($movie_file, $title[$x]);

$over[$x]=$data->results[$x]->overview;
//The 'data' JSON object array contains the overview/summary who played their part in the movie and the plot of movie in short.
$poster[$x] = " http://image.tmdb.org/t/p/w185".$data->results[$x]->poster_path;
//The JSOM returns the image link which is relative, in order to make it an absolute link it will be required that a hard coded link is concatenated with the poster url.
echo "\n".$poster[$x]."\n";

#$orig_poster = $poster[$x];
//Debugging purposes console output.
#fwrite($movie_poster, $poster[$x]."\n");

#array_push($orig_poster,$poster[$x]);
#download_poster($poster[$x],$x);
$doc = new DOMDocument();
libxml_use_internal_errors(true);
$doc->loadHTMLFile("C:\Users\Ahmar Zafar\Desktop\SentimentAnalysis-master\Website\Website\index.html");
libxml_clear_errors();
$plink = $doc->getElementById(($x+1).'p');

#$link = $doc->createElement('a');
#$newLink = $body->appendChild($link);
$plink->setAttribute("src", $poster[$x]);
#$linkText = $doc->createTextNode("Display Text For Link");
#$newLink->appendChild($linkText);
$doc->saveHTMLFile("C:\Users\Ahmar Zafar\Desktop\SentimentAnalysis-master\Website\Website\index.html");



}

exec("Rscript words.r",$call_file);
//Calling the R file which is used to fetch data from Twitter, and make sentiment calculations for the same. The name of the movie and actor are passed as command line arguments to the R file execution.
var_dump($call_file);
//Debugging purposes console output.



fclose($movie_poster);

?>


