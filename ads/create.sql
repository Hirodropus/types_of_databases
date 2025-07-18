CREATE TABLE IF NOT EXISTS Genres (
  id SERIAL PRIMARY KEY,
  Title varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Singers (
  id SERIAL PRIMARY KEY,
  NickName VARCHAR(255) NOT NULL,
  description TEXT
);

CREATE TABLE IF NOT EXISTS Albums (
  id SERIAL PRIMARY KEY,
  AlbumName varchar(255) NOT NULL,
  release_year INTEGER
);

CREATE TABLE IF NOT EXISTS Tracks (
  id SERIAL  PRIMARY KEY,
  Name varchar(255) NOT NULL,
  Duration INTEGER NOT NULL,
  Albums_id INTEGER NOT NULL REFERENCES Albums (id)
);

CREATE TABLE IF NOT EXISTS Compilations (
  id SERIAL PRIMARY KEY,
  Title varchar(255) NOT NULL,
  release_year INTEGER
);

CREATE TABLE IF NOT EXISTS Singer_Genres (
  Genres_id INTEGER REFERENCES Genres (id),
  Singers_id INTEGER REFERENCES Singers (id),
  CONSTRAINT Singer_Genres_pk PRIMARY KEY (Singers_id, Genres_id)
);

CREATE TABLE IF NOT EXISTS Album_Singer (
  Albums_id INTEGER REFERENCES Albums (id),
  Singers_id INTEGER REFERENCES Singers (id),
  CONSTRAINT Album_Singer_pk PRIMARY KEY (Albums_id, Singers_id)
);

CREATE TABLE IF NOT EXISTS Compilation_Track (
  Compilations_id INTEGER REFERENCES Compilations (id),
  Tracks_id INTEGER REFERENCES Tracks (id),
  CONSTRAINT Compilation_Track_pk PRIMARY KEY (Compilations_id, Tracks_id)
);
