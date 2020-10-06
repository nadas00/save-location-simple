// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorLocationDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocationDatabaseBuilder databaseBuilder(String name) =>
      _$LocationDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocationDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$LocationDatabaseBuilder(null);
}

class _$LocationDatabaseBuilder {
  _$LocationDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$LocationDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$LocationDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<LocationDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$LocationDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$LocationDatabase extends LocationDatabase {
  _$LocationDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LocationDao _locationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Location` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `description` TEXT, `latitude` REAL, `longitude` REAL, `lastVisit` TEXT, `categoryColour` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  LocationDao get locationDao {
    return _locationDaoInstance ??= _$LocationDao(database, changeListener);
  }
}

class _$LocationDao extends LocationDao {
  _$LocationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _locationInsertionAdapter = InsertionAdapter(
            database,
            'Location',
            (Location item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'lastVisit': item.lastVisit,
                  'categoryColour': item.categoryColour
                },
            changeListener),
        _locationUpdateAdapter = UpdateAdapter(
            database,
            'Location',
            ['id'],
            (Location item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'lastVisit': item.lastVisit,
                  'categoryColour': item.categoryColour
                },
            changeListener),
        _locationDeletionAdapter = DeletionAdapter(
            database,
            'Location',
            ['id'],
            (Location item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'lastVisit': item.lastVisit,
                  'categoryColour': item.categoryColour
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _locationMapper = (Map<String, dynamic> row) => Location(
      id: row['id'] as int,
      name: row['name'] as String,
      description: row['description'] as String,
      latitude: row['latitude'] as double,
      longitude: row['longitude'] as double,
      lastVisit: row['lastVisit'] as String,
      categoryColour: row['categoryColour'] as String);

  final InsertionAdapter<Location> _locationInsertionAdapter;

  final UpdateAdapter<Location> _locationUpdateAdapter;

  final DeletionAdapter<Location> _locationDeletionAdapter;

  @override
  Future<Location> findLocationById(int id) async {
    return _queryAdapter.query('SELECT * FROM location WHERE id = ?',
        arguments: <dynamic>[id], mapper: _locationMapper);
  }

  @override
  Future<Location> findLocationByColor(String color) async {
    return _queryAdapter.query(
        'SELECT * FROM location WHERE categoryColour = ?',
        arguments: <dynamic>[color],
        mapper: _locationMapper);
  }

  @override
  Future<List<Location>> findAllLocations() async {
    return _queryAdapter.queryList('SELECT * FROM location',
        mapper: _locationMapper);
  }

  @override
  Stream<List<Location>> findAllLocationsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM location',
        tableName: 'Location', mapper: _locationMapper);
  }

  @override
  Future<void> insertLocation(Location location) async {
    await _locationInsertionAdapter.insert(
        location, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateLocation(Location location) async {
    await _locationUpdateAdapter.update(
        location, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteLocation(Location location) async {
    await _locationDeletionAdapter.delete(location);
  }

  @override
  Future<void> deleteLocations(Location location) async {
    await _locationDeletionAdapter.delete(location);
  }
}
