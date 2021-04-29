# Creating a Microservice in Go

## Introduction


<!-- vim-markdown-toc GFM -->

- [Golang programming](#golang-programming)
- [Understand Database in Go](#understand-database-in-go)
- [Understand Web server and Router in Go](#understand-web-server-and-router-in-go)
	- [Router](#router)
	- [Web server](#web-server)
- [CRUD operations](#crud-operations)
	- [Create operation - `C`RUD in Go](#create-operation---crud-in-go)
	- [Update operation - CR`U`D in Go](#update-operation---crud-in-go)
	- [Delete operation - CRU`D` in Go](#delete-operation---crud-in-go)
- [Diagram as code](#diagram-as-code)

<!-- vim-markdown-toc -->

<p align="center"><img width=50% src="go-microservice.png"></p>

🔧 **Technologies & Tools:**
[![](https://img.shields.io/badge/Technology%20Stack-Microservice-informational?style=flat&color=2bbc8a)](#crud-operations)
[![](https://img.shields.io/badge/Programming%20Language-Golang-information?style=flat&color=2bbc8a)](#golang-programming)
![](https://img.shields.io/badge/OS%20Environment-Linux%20&%20Bash-informational?style=flat&color=2bbc8a)
[![](https://img.shields.io/badge/Diagram%20as%20Code-Golang-informational?style=flat&color=2bbc8a)](#diagram-as-code)

### Golang programming
◾ File                          | 🔰 Function
:--------------------------------|:-----------------------------------------------------------------------------------------------------------------------------
main.go                          | main infra logic responsible for connecting to the database, setting up the routing, and starting the server
handler.go                       | business logic for the microservice, involve reading in data from the user, building entities, and returning data to the user

***Usage:*** *Build and Run go program*

```bash
cd microservice
go build -o api
./api
```
> You should see output like `2021/04/28 00:37:37 starting server on port 8000`

### Understand Database in Go

> This Program need a database with a `TABLE called games`. Its schema is very simple, having a `unique ID` for each game, along with its `title, console, rating, and completion status`. There is also a `timestamp` for when the game was added, and when it was last updated. These will be read-only fields within your microservice that the user cannot modify.

```sql
CREATE TABLE IF NOT EXISTS games (
id SERIAL NOT NULL,
title TEXT,
console TEXT,
rating FLOAT,
complete BOOLEAN,
created TIMESTAMP,
updated TIMESTAMP,
CONSTRAINT games_pkey PRIMARY KEY (id)
);
```

***Connection logic***

> `Connect()` function in main.go. - This handles the database connection.

```golang
func ConnectDB() error {
  // build database connection string
dbinfo := fmt.Sprintf(
    "user=%s password=%s host=%s dbname=%s sslmode=disable",
    DatabaseUser,
    DatabasePassword,
    DatabaseHost,
    DatabaseName,
)
```
> Builds a connection string that the database/sql package knows how to use to connect to the database. At the top of main.go, there are a few consts that hold your default values for the database.

```golang
const (
  DatabaseUser     = "postgres"
  DatabasePassword = "mypassword"
  DatabaseHost     = "pgdb"
  DatabaseName     = "postgres"
)
```

```golang
var err error
db, err = sql.Open("postgres", dbinfo)
if err != nil {
    return err
}
```
> This attempts to open a connection to the database. It will only return an error if the first parameter is of an unknown database driver. We haven't tested if the connection to the database actually works. We return a quick check to see if we do indeed have established a connection to your database.

```golang
return db.Ping()
```
> If your Ping() command fails, it will return an error and your logic in main() will handle it accordingly.

### Understand Web server and Router in Go

#### Router

> How the routes are created and handled. To define a route, we use the HandleFunc function. It takes two parameters: a path and a function. The second parameter must be of type `func(http.ResponseWriter, *http.Request)`. Which makes mux compatible with Go's http.Handler interface so it is compatible with the standard http.ServeMux. The web server has a router that manages five different cases to perform the basic CRUD operations.

```golang
// create a new game - POST only
router.HandleFunc("/games", CreateGameHandler).Methods(http.MethodPost)
// get all games - GET only
router.HandleFunc("/games", RetrieveGamesHandler).Methods(http.MethodGet)
// get a specific game - GET only
router.HandleFunc("/games/{id:[0-9]+}", RetrieveGameHandler).Methods(http.MethodGet)
// update a specific game - PUT or PATCH only
router.HandleFunc("/games/{id:[0-9]+}", UpdateGameHandler).Methods(http.MethodPut, http.MethodPatch)
// delete a specific game - DELETE only
router.HandleFunc("/games/{id:[0-9]+}", DeleteGameHandler).Methods(http.MethodDelete)
```

> Notice how the server defined five different handlers, but technically only two paths: /games and /games/{id}. The mux package allows you to limit a route to specific HTTP methods, allowing greater control of your service. Each CRUD operation gets its own function!

> Take notice at the {id:[0-9]+} within the endpoint. This tells mux to only allow URLs with numbers (or for us IDs), to route to those specific HandlerFuncs. We can have mux pull the ID from the URL and we can use that in your database query get a specific entity.

#### Web server

```golang
log.Println("starting server on port 8000")
log.Fatal(http.ListenAndServe(":8000", router))
```

> The Go standard library does all work of executing a server. You only need to provide the host to listen on, and rules on which to route. For this case, you'll listen on localhost and on port 8000. In a production environment, or within a container, it may be best to use 0.0.0.0:8000 to have it listen on all interfaces.

> Summary: `main.go`

- [x] import section
- [x] const and var definitions
- [x] struct 
   - [x] Table schema 
   - [x] Json Error 
- [x] Functions 
   - [x] ConnectDB
      - [x] PingDB
   - [x] Main
      - [x] ConnectDB
      - [x] Router handlers
         - [x] CreateGameHandler
         - [x] RetrieveGamesHandler
         - [x] RetrieveGameHandler
         - [x] UpdateGameHandler
         - [x] DeleteGameHandler
      - [x] Start Web server 

<details><summary><i>Click here to read full code of main.go</i></summary><br>

```golang
package main

import (
  "database/sql"
  "fmt"
  "log"
  "net/http"
  "time"

  "github.com/gorilla/mux"
  _ "github.com/lib/pq"
)

const (
  DatabaseUser     = "postgres"
  DatabasePassword = "mypassword"
  DatabaseHost     = "pgdb"
  DatabaseName     = "postgres"
)

var (
  db *sql.DB
)

/*********
* MODEL *
*********/
// Game is a simple model to store video game data and encoded/decoded through JSON.
// Has an id, title, console, rating, completed status, time created, and time updated.
type Game struct {
  ID       int       `json:"id"`
  Title    string    `json:"title"`
  Console  string    `json:"console"`
  Rating   float64   `json:"rating"`
  Complete bool      `json:"complete"`
  Created  time.Time `json:"created"`
  Updated  time.Time `json:"updated"`
}

// JsonErr is an error wrapper that can easily be Marshaled
// into JSON and retruned through a handler
type JsonErr struct {
  Error string `json:"error"`
}

/************
* DATABASE *
************/
// ConnectDB builds a connection string and connects to a
// PostgreSQL database using the standard libray's sql.DB type.
// Returns an error if the connection fails.
func ConnectDB() error {
  // build database connection string
  dbinfo := fmt.Sprintf(
    "user=%s password=%s host=%s dbname=%s sslmode=disable",
    DatabaseUser,
    DatabasePassword,
    DatabaseHost,
    DatabaseName,
  )

  // connect to database
  var err error
  db, err = sql.Open("postgres", dbinfo)
  if err != nil {
    return err
  }

  return db.Ping()
}

func main() {
  err := ConnectDB()
  if err != nil {
    log.Fatal(err)
  }

  router := mux.NewRouter()
  // create a new game - POST only
  router.HandleFunc("/games", CreateGameHandler).Methods(http.MethodPost)
  // get all games - GET only
  router.HandleFunc("/games", RetrieveGamesHandler).Methods(http.MethodGet)
  // get a specific game - GET only
  router.HandleFunc("/games/{id:[0-9]+}", RetrieveGameHandler).Methods(http.MethodGet)
  // update a specific game - PUT or PATCH only
  router.HandleFunc("/games/{id:[0-9]+}", UpdateGameHandler).Methods(http.MethodPut, http.MethodPatch)
  // delete a specific game - DELETE only
  router.HandleFunc("/games/{id:[0-9]+}", DeleteGameHandler).Methods(http.MethodDelete)

  log.Println("starting server on port 8000")
  log.Fatal(http.ListenAndServe(":8000", router))
}
```

</details><br>

### CRUD operations

#### Create operation - `C`RUD in Go

- [x] Create a game entity within the database
  - [x] Read in the JSON data from the user, parsed it, and turned it into a structure that your Go code can understand
  - [x] Insert into database
- [x] Query the database for a specific game and return the data to the user in JSON format
  - [x] Retrieve ID from the URL and used it as a parameter for the database query
- [x] Return a JSON array of games

* Convert the POST body JSON to a Game type within Go.
* Insert the data into the database.
* Get the newly created game from the database.
* Return the data to the user.

> To convert the JSON into a Game type, you'll first need to read the body from the http.Request. Fortunately, there is an aptly named field, Body, which is of type io.ReadCloser. We can leverage json.NewDecoder method, which accepts an io.Reader interface, and can then use Decode it into an empty Game struct. If for any reason, this causes and error, you should report back to the user an error message and return the http.StatusBadRequest in the header.

```golang
var game Game
defer r.Body.Close()
err := json.NewDecoder(r.Body).Decode(&game)
if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(
        &JsonErr{Error: "unable to create game, please check your data"},
    )
    return
}
```
> The json.Encoder and json.Decoder accept an io.Writer and io.Reader, respectively. Passing in the http.ResponseWriter will write out the error message to the HTTP response to the user. Notice how there is a custom JsonErr struct. Using this as a wrapper for the errors, makes it easier to display error messages to the user.
You'll need to INSERT the game into the database. You'll need to use the QueryRow method. You might be wondering why use QueryRow when we're trying to do an INSERT. This is because you want to get the lastInsertId of the game. This is a workaround when using PostgreSQL. Within the SQL statement, you'll need to add RETURNING id at the end of the INSERT statement. Then, use the Scan function to save the ID as a variable. You'll need this to get the new game and display it back to the user.

> The SQL to insert into the database:

```sql
INSERT INTO games(title, console, rating, complete, created, updated) VALUES($1, $2, $3, $4, $5, $5) returning id
```

```golang
var lastInsertId int
err = db.QueryRow(
    "INSERT INTO games(title, console, rating, complete, created, updated) VALUES($1, $2, $3, $4, $5, $5) returning id",
    game.Title,
    game.Console,
    game.Rating,
    game.Complete,
    time.Now(),
).Scan(&lastInsertId)
if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(
        &JsonErr{Error: "unable to write to database: " + err.Error()},
    )
    return
}
```
> Start by creating an int called lastInsertId to store the ID from the database. The INSERT statement passes in all the data from the game variable, except created and updated. Since we're creating a new row in the database, both will have the same value. Notice in the SQL statement how the fifth variable, $5, is passed twice. Within the variables being passed into QueryRow, send the current time with time.Now().
> You'll get the data fresh from the database to be returned to the user. Use the QueryRow function again, to retrieve a single row from the database and Scan it into the current game.

```sql
SELECT * FROM games g WHERE g.id = $1
```
> This is similar to the INSERT statement from earlier, but you'll change the SQL statement. You will still want to use the Scan function and scan the values from the database into the game variable.

```golang
err = db.QueryRow("SELECT * FROM games g WHERE g.id = $1", lastInsertId).Scan(
    &game.ID,
    &game.Title,
    &game.Console,
    &game.Rating,
    &game.Complete,
    &game.Created,
    &game.Updated,
)
if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(
        &JsonErr{Error: "unable to read from database: " + err.Error()},
    )
    return
}
```

> In the SQL statement, you'll pass in the lastInsertId from before. You could have simply added lastInsertId to the game variable and returned it, but it's good practice to grab the most current information from the database. This is especially true if you have a complex dataset with TRIGGERs on an INSERT or an UPDATE. Plus, this will set up the next section nicely, Retrieving.

> Before retrieving, you need to display the JSON data to the user. Make sure you change the status to http.StatusCreated. Use the json.NewEncoder pattern from the JsonErr section from earlier.
```golang
w.WriteHeader(http.StatusCreated)
json.NewEncoder(w).Encode(&game)
```

***Testing*** - To test that the endpoint is working properly, use curl again to try and create some games in the database. If not already open, go to the terminal within your IDE. Build the microservice, as before, with go build -o api and then run it with ./api. Now open another terminal alongside it and run the following commands:

```bash
# add curl to PATH
export PATH=$PATH:/bin:/usr/bin

# api test 1
curl -X POST -d '{"title":"Super Mario Bros.", "console":"NES", "rating":4.8, "complete":true}' localhost:8000/games

# output
# {"id":1,"title":"Super Mario Bros.","console":"NES","rating":4.8,"complete":true,"created":"timestamp","updated":"timestamp"}

# api test 2
curl -X POST -d '{"title":"Sonic 3", "console":"GENESIS", "rating":5, "complete":false}' localhost:8000/games
# output
# {"id":2,"title":"Sonic 3","console":"GENESIS","rating":5,"complete":false,"created":"timestamp","updated":"timestamp"}
```

> The created and updated timestamps will be different, but you should now have two games in your database! Feel free to try and add a couple more in yourself. What happens if you give it malformed JSON data?

> Building off some of the code in the Create phase, you'll query the database for a specific game and return the data to the user. If the Id of the game is invalid, return a 404 Error message. This can be broken down into the following tasks:

* Read the ID from the URL
* Query the Database for the game with the specific ID.
* Write the data to the user.

> Remove the template code from RetrieveGameHandler (notice Game and not Games). Most of this will be using the same code to get the data from the CreateGameHandler. However, you will need to get the ID from the URL, using the mux.Vars function.

```golang
params := mux.Vars(r)
id := params["id"]
```
> The mux.Vars method will create a map of all the parameters within the URL.

> Using the SELECT code from the last section, try and complete this endpoint. Be sure to return a 404 Not Found response if the database throws an error.

```golang
var game Game
err := db.QueryRow("SELECT * FROM games g WHERE g.id = $1", id).Scan(
    &game.ID,
    &game.Title,
    &game.Console,
    &game.Rating,
    &game.Complete,
    &game.Created,
    &game.Updated,
)

if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
}
```

> Since the data returned is legitimate, encode the struct into JSON and write to the response.

> The default header with a http.ResponseWriter will be a http.StatusOK, no need to explicitly define it.
***Testing*** - If your previous build of the microservice is still running, stop it by pressing CTRL + C. Build and run it again so you can test with your latest changes.

```bash
curl localhost:8000/games/1
curl localhost:8000/games/2
```
> You will see the data matching the output from RetrieveGameHandler. If you created a game or two of your own, check that you can retrieve it as well.

> Returning a single game is great, but `how about returning all of them?` The task can be broken down into three parts:

* Query the database for all games
* For each row returned, add the Game data to an array of Games.
* Marshal the array to JSON data and return it to the user.

> Remove the template code from RetrieveGamesHandler (notice Games this time, not Game).

> Instead of using QueryRow, you'll use the Query function to get multiple rows from the database. This is will a simple SELECT * FROM query. Try to make it so the results are always in ascending order by their IDs.

```golang
games := make([]Game, 0)

rows, err := db.Query("SELECT * FROM games g ORDER BY g.id")
if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    json.NewEncoder(w).Encode(
        &JsonErr{Error: "unable to retreive games at this time: " + err.Error()},
    )
    return
}
```
> Now that you have the results, you need to iterate over the rows. Use the rows.Next() function. It will move to the next row within the cursor and return false when there are no more rows to process. Just as before, you'll need to Scan into a game variable, and then append that to an array.

```golang
for rows.Next() {
    var game Game
    rows.Scan(
        &game.ID,
        &game.Title,
        &game.Console,
        &game.Rating,
        &game.Complete,
        &game.Created,
        &game.Updated,
    )

    games = append(games, game)
}
```
> Finally, return the array as JSON to the user.

```golang
json.NewEncoder(w).Encode(games)
```

***Testing*** you will need to rebuild your newly created server. Use CTRL + C to quit the currently running instance; build it with go build -o api, and finally run it using ./api. In another terminal window, execute the following commands:

```bash
# get all games in collection
curl localhost:8000/games
```

#### Update operation - CR`U`D in Go

> How would you go about updating a game's information? Perhaps the title is misspelled, or that the complete flag needs to be changed to true instead of false? Updating can be tricky because there are a few fields that you don't want the user to be able to manipulate:

* ID
* Created
* Updated

This is the breakdown of the steps you will need to take to properly (and safely) update a game:

* Get the ID from the parameters
* Query the database for the game. Return 404 if not found.
* Make a copy of the "read-only" variables
* Read in request data as JSON and overwrite existing struct game data
* Replace the "read-only" fields with previously captured variables
* Write to database
* Return data to the user

> Go to the UpdateGameHandler function located in handler.go and remove the stub implementation before implementing the working code in the following instructions.

> Read the ID from the URL. Remember to use the mux package to read its Vars.

```golang
params := mux.Vars(r)
id := params["id"]
```
> Now that you have the id from the URL, query the database and retrieve game data into a struct. If the game data is not found (a database error is returned), return a 404 response to the user.

```golang
var game Game
err := db.QueryRow("SELECT * FROM games g WHERE g.id = $1", id).Scan(
    &game.ID,
    &game.Title,
    &game.Console,
    &game.Rating,
    &game.Complete,
    &game.Created,
    &game.Updated,
)

if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
}
```
> Now you'll need to make a copy of the "read-only" attributes. Be sure to get the ID and Created fields, and make sure to set Updated to the current time.

```golang
// handle "read-only" attributes
created := game.Created
updated := time.Now()
gid := game.ID
```

> Next, read in the request.Body, and using a json.NewDecoder, Decode the data into the current game variable. The reason for doing it this way instead of reading in a new variable and copying is that you want to support partial updates. This will allow the user to simply provide JSON data for only the fields they want updated. For example, { "title": "Metroid Prime" } will only update the title. This is how the decoder works and only writes to key/values in fields it finds and ignores the rest. Meaning rather than writing an empty string for game.Console, it will have the database data stored in the field. With that, try and read in the data and overwrite the game data.


```golang
// overwrite data with provided JSON
defer r.Body.Close()
err = json.NewDecoder(r.Body).Decode(&game)
if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(
        &JsonErr{Error: "bad JSON data, please check the update data"},
    )
    return
}
```
> Next, update the game "read-only" fields that you saved earlier.

```golang
// update game and then run query
game.ID = gid
game.Created = created
game.Updated = updated
```

> Using the SQL below, try and to write the Go code that will update the database.

```sql
"UPDATE games g SET title = $1, console = $2, rating = $3, complete = $4, created = $5, updated = $6 WHERE g.id = $7"
```

> Rather than using QueryRow in previous steps, you can use the db.Exec function. With an UPDATE, you won't have a lastInsertId, nor will you have any data returned. Making this perfect for the update use case. It's important to know the difference between Query, QueryRow, Exec, and others and when to use which. A lot of the same statements can be achieved using either function, but each provides a slightly different functionality. Be sure to read the database/sql package documentation for more information.

```golang
_, err = db.Exec(
    "UPDATE games g SET title = $1, console = $2, rating = $3, complete = $4, created = $5, updated = $6 WHERE g.id = $7",
    game.Title,
    game.Console,
    game.Rating,
    game.Complete,
    game.Created,
    game.Updated,
    game.ID,
)
```
> Write the data in JSON to the user. This shows that the data was successfully written to the database.

```golang
json.NewEncoder(w).Encode(&game)
```

***Testing*** - Build the Go microservice by using the terminal:

```bash
go build -o api
./api
```
> Give it a moment while Go downloads the dependencies, and once it's started, you will see starting server on port 8000 in your terminal.
Perform an update test using the /games endpoint with either PUT or PATCH. Make sure you have your two terminals open, you've built the latest changes and have started the server with ./api. For this endpoint, the server only allows PUT or PATCH requests. With your other terminal open, enter the following commands.

```bash
# update game 1 with a new title
curl -X PUT -d '{ "title":"Super Mario Brothers" }' localhost:8000/games/1

# output
# {"id":1,"title":"Super Mario Brothers","console":"NES","rating":4.8,"complete":true,"created":"timestamp","updated":"timestamp"}

# update game 2 with two different fields
curl -X PATCH -d '{ "rating":3.9, "complete":true}' localhost:8000/games/2

# output
# {"id":2,"title":"Sonic 3","console":"GENESIS","rating":3.9,"complete":true,"created":"timestamp","updated":"timestamp"}
```

> Notice how in your terminal output "created" is the same as before, but "updated" has been changed to the current time! This is exactly how it should be operating!


> Go one step further, and try to change the ID of a game. What happens? What about trying to change created or updated?

#### Delete operation - CRU`D` in Go

> This is the last segment of the CRUD operations, DELETE. Go to DeleteGameHandler in handler.go 

```sql
"DELETE FROM games g WHERE g.id = $1"
```
Instructions

> Go to DeleteGameHandler in handler.go and remove the template code. Similar to other handlers, you'll need to get the ID from the URL first.

```golang
params := mux.Vars(r)
id := params["id"]
```

> Next, attempt to delete the row from the database. If the user enters an ID that doesn't exist, the database driver will return an error, to which you can return a 404 Not Found response.

```golang
_, err := db.Exec("DELETE FROM games g WHERE g.id = $1", id)
if err != nil {
    w.WriteHeader(http.StatusNotFound)
    json.NewEncoder(w).Encode(
        &JsonErr{Error: "unable to delete game: " + err.Error()},
    )
    return
}
```
> Finally, in the spirit of being RESTful, we return a response code of http.StatusNoContent (204), without any data.

```golang
w.WriteHeader(http.StatusNoContent)
```

***Testing*** - Like all good programmers, you want to test to makes sure your code is functioning as intended. Make sure you have your two terminals open, you've built the latest changes and have started the server with ./api. This endpoint only accepts the DELETE http request. You're going to use the normal curl command, but with an extra flag this time, -i. This will show the response HEADER. You'll want to confirm that on a successful DELETE operation, a 204 response is returned. Otherwise, the response will be empty and you will not know if operation actually worked.

```bash
# update game 1 with a new title
curl -i -X DELETE localhost:8000/games/1

# output
# HTTP/1.1 204 No Content
# Date: ...
```

> Summary: `handler.go`

<details><summary><i>Click here to read full code of handler.go</i></summary><br>

```golang
package main

import (
  "encoding/json"
  "net/http"
  "time"

  "github.com/gorilla/mux"
)

// CreateGameHandler reads in JSON data and creates a new Game within the database
// Returns HTTP Code 201 and JSON data of the newly created game
func CreateGameHandler(w http.ResponseWriter, r *http.Request) {
  var game Game
  defer r.Body.Close()
  err := json.NewDecoder(r.Body).Decode(&game)
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(
      &JsonErr{Error: "unable to create game, please check your data"},
    )
    return
  }

  var lastInsertId int
  err = db.QueryRow(
    "INSERT INTO games(title, console, rating, complete, created, updated) VALUES($1, $2, $3, $4, $5, $5) returning id",
    game.Title,
    game.Console,
    game.Rating,
    game.Complete,
    time.Now(),
  ).Scan(&lastInsertId)
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(
      &JsonErr{Error: "unable to write to database: " + err.Error()},
    )
    return
  }

  game = Game{}
  db.QueryRow("SELECT * FROM games g WHERE g.id = $1", lastInsertId).Scan(
    &game.ID,
    &game.Title,
    &game.Console,
    &game.Rating,
    &game.Complete,
    &game.Created,
    &game.Updated,
  )

  w.WriteHeader(http.StatusCreated)
  json.NewEncoder(w).Encode(&game)
}

// RetrieveGameHandler reads the ID from the URL (using mux) and queries the database for
// the game in question.
// Returns 200 and JSON data if the game exists, otherwise returns a 404
func RetrieveGameHandler(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  id := params["id"]

  var game Game
  err := db.QueryRow("SELECT * FROM games g WHERE g.id = $1", id).Scan(
    &game.ID,
    &game.Title,
    &game.Console,
    &game.Rating,
    &game.Complete,
    &game.Created,
    &game.Updated,
  )

  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusCreated)
  json.NewEncoder(w).Encode(&game)
}

// UpdateGameHandler queries the database for the ID of the game to be updated.
// Replaces the writeable data within the game with the JSON data,
// and rewrites the game to the database.
// Returns HTTP Code 200 with newly update game data
func UpdateGameHandler(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  id := params["id"]

  var game Game
  err := db.QueryRow("SELECT * FROM games g WHERE g.id = $1", id).Scan(
      &game.ID,
      &game.Title,
      &game.Console,
      &game.Rating,
      &game.Complete,
      &game.Created,
      &game.Updated,
  )
  
  if err != nil {
      w.WriteHeader(http.StatusNotFound)
      return
  }
  // handle "read-only" attributes
  created := game.Created
  updated := time.Now()
  gid := game.ID

  // overwrite data with provided JSON
  defer r.Body.Close()
  err = json.NewDecoder(r.Body).Decode(&game)
  if err != nil {
      w.WriteHeader(http.StatusBadRequest)
      json.NewEncoder(w).Encode(
          &JsonErr{Error: "bad JSON data, please check the update data"},
      )
      return
  }
  
  // update game and then run query
  game.ID = gid
  game.Created = created
  game.Updated = updated

  _, err = db.Exec(
      "UPDATE games g SET title = $1, console = $2, rating = $3, complete = $4, created = $5, updated = $6 WHERE g.id = $7",
      game.Title,
      game.Console,
      game.Rating,
      game.Complete,
      game.Created,
      game.Updated,
      game.ID,
  )

  json.NewEncoder(w).Encode(&game)
  // w.WriteHeader(http.StatusOK)
  // w.Write([]byte("not implemented\n"))
}

// DeleteGameHandler removes the game from the database based off the ID passed in through the URL.
// Returns HTTP Code 204 if successful, 404 if no game exists for ID
func DeleteGameHandler(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  id := params["id"]

  _, err := db.Exec("DELETE FROM games g WHERE g.id = $1", id)
  if err != nil {
      w.WriteHeader(http.StatusNotFound)
      json.NewEncoder(w).Encode(
          &JsonErr{Error: "unable to delete game: " + err.Error()},
      )
      return
  }
  w.WriteHeader(http.StatusNoContent)
  // w.Write([]byte("not implemented\n"))
}

// RetrieveGamesHandler returns all games in collection as a JSON array
func RetrieveGamesHandler(w http.ResponseWriter, r *http.Request) {
  games := make([]Game, 0)

  rows, err := db.Query("SELECT * FROM games g ORDER BY g.id")
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    json.NewEncoder(w).Encode(
      &JsonErr{Error: "unable to retreive games at this time: " + err.Error()},
    )
    return
  }

  for rows.Next() {
    var game Game
    rows.Scan(
      &game.ID,
      &game.Title,
      &game.Console,
      &game.Rating,
      &game.Complete,
      &game.Created,
      &game.Updated,
    )

    games = append(games, game)
  }

  json.NewEncoder(w).Encode(games)
}

// RetrieveGamesByConsoleHandler is a simple filter/search method to return all games of a specific console
// Reads the console from the URL and queries the database.
// Returns HTTP Code 200 with all game data, if sent an "invalid" console, an empty array is returned
func RetrieveGamesByConsoleHandler(w http.ResponseWriter, r *http.Request) {
  w.WriteHeader(http.StatusOK)
  w.Write([]byte("not implemented\n"))
}
```

</details><br>

### Diagram as code

<details><summary><i>Click here to view diagram-in-go-code</i></summary><br>

```golang
package main

import (
	"log"

	"github.com/blushft/go-diagrams/diagram"
	"github.com/blushft/go-diagrams/nodes/gcp"
	"github.com/blushft/go-diagrams/nodes/programming"
        "github.com/blushft/go-diagrams/nodes/apps"
)

func main() {
	d, err := diagram.New(diagram.Filename("go-microservice"), diagram.Label("Microservice in Go"), diagram.Direction("LR"))
	if err != nil {
		log.Fatal(err)
	}

	ide := apps.Client.Client().Label("IDE")
	app := programming.Language.Go().Label("Go")
	db := apps.Database.Postgresql().Label("DB")
	cgh := gcp.Database.Memorystore(diagram.NodeLabel("CreateGameHandler"))
	rgsh := gcp.Database.Memorystore(diagram.NodeLabel("RetrieveGamesHandler"))
	rgh := gcp.Database.Memorystore(diagram.NodeLabel("RetrieveGameHandler"))
	ugh := gcp.Database.Memorystore(diagram.NodeLabel("UpdateGameHandler"))
	dgh := gcp.Database.Memorystore(diagram.NodeLabel("DeleteGameHandler"))
	web := gcp.Compute.ComputeEngine(diagram.NodeLabel("Web Server"))
	router := gcp.Compute.ComputeEngine(diagram.NodeLabel("Microservice router"))
	m := gcp.Compute.ComputeEngine(diagram.NodeLabel("main.go"))
	h := gcp.Compute.ComputeEngine(diagram.NodeLabel("handler.go"))


	dc := diagram.NewGroup("Golang")
	dc.NewGroup("codes").
	    Label("Golang codes").
	    Add(m).
	    ConnectAllFrom(app.ID(), diagram.Forward()).
	    ConnectAllTo(web.ID(), diagram.Forward()).
	    Add(h)

	dc.NewGroup("data").Label("Data Layer").Add(db).ConnectAllFrom(m.ID(), diagram.Forward())

	dc.NewGroup("web service").Label("Web Layer").Add(web).ConnectAllFrom(m.ID(), diagram.Forward()).ConnectAllTo(router.ID(), diagram.Forward())

	dc.NewGroup("microservices").Label("Router and handlers").Add(router, cgh, rgsh, rgh, ugh, dgh).Connect(router, cgh).Connect(router, rgsh).Connect(router, rgh).Connect(router, ugh).Connect(router, dgh)

	d.Connect(ide, app, diagram.Forward()).Group(dc)
	d.Connect(cgh, h).Connect(rgsh, h).Connect(rgh, h).Connect(ugh, h).Connect(dgh, h)

	if err := d.Render(); err != nil {
		log.Fatal(err)
	}
}
```

</details><br>

