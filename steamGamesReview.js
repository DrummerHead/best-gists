// Go to http://steamcommunity.com/id/{{USERNAME}}/games/?tab=all&sort=name
// for example: http://steamcommunity.com/id/DrummerHead/games/?tab=all&sort=name

// now copy and paste this into your console:
// ( what is a console? http://webmasters.stackexchange.com/questions/8525/how-to-open-the-javascript-console-in-different-browsers )

var games = document.querySelectorAll('.gameListRowItemName');

var engines = {
  youtube : function(query) {
    return 'http://www.youtube.com/results?search_query=' + query;
  },
  metacritic : function(query) {
    return 'http://www.metacritic.com/search/all/' + query + '/results';
  }
}

var makeUrl = function(query, id){
  var safeUrl = query
    .replace(/%/g, '%25')
    .replace(/#/g, '%23')
    .replace(/&/g, '%26')
    .replace(/\+/g, '%2B')
    .replace(/\?/g, '%3F')
    .replace(/[ ]+/g, '+');
  var urlResult = engines[id](safeUrl);
  return urlResult;
}

for(var i = 0; i < games.length; i++){
  var text = games[i].textContent;
  var youtube = makeUrl(text, 'youtube');
  var metacritic = makeUrl(text, 'metacritic');
  console.info(youtube);
  console.info(metacritic);
}

// now copy and paste the results into http://mcdlr.com/make-links/ and get proper links. Profit!