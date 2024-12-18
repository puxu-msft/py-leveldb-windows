#pragma once

#include <Python.h>
#include <structmember.h>

#if PY_MAJOR_VERSION < 3 || (PY_MAJOR_VERSION == 3 && PY_MINOR_VERSION < 7)
#error "Using https://github.com/happynear/py-leveldb-windows if < Python 3.7"
#endif

#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

#include <leveldb/db.h>
#include <leveldb/write_batch.h>
#include <leveldb/comparator.h>
#include <leveldb/cache.h>

#include <vector>

#ifdef LEVELDB_EXT_EXPORTS
#define LEVELDB_EXT_API __declspec(dllexport)
#else
#define LEVELDB_EXT_API __declspec(dllimport)
#endif

typedef struct {
    PyObject_HEAD

    // object is open if all of these are non-null,
    // once an object has been closed, it can not be re-opened
    leveldb::DB* _db;

    leveldb::Options* _options;
    leveldb::Cache* _cache;
    const leveldb::Comparator* _comparator;

    // number of open snapshots, associated with LevelDB object
    int n_snapshots;

    // number of open iterators, associated with LevelDB object
    int n_iterators;
} PyLevelDB;

typedef struct {
    PyObject_HEAD

    // the associated LevelDB object
    PyLevelDB* db;

    // the snapshot
    const leveldb::Snapshot* snapshot;
} PyLevelDBSnapshot;

typedef struct {
    PyObject_HEAD

    // the associated LevelDB object or snapshot
    PyObject* ref;

    // the associated db object
    PyLevelDB* db;

    // the iterator
    leveldb::Iterator* iterator;

    // upper/lower limit, inclusive, if any
    std::string* bound;

    // iterator direction
    int is_reverse;

    // if 1: return (k, v) 2-tuples, otherwise just k
    int include_value;
} PyLevelDBIter;

typedef struct {
    bool is_put;
    std::string key;
    std::string value;
} PyWriteBatchEntry;

typedef struct {
    PyObject_HEAD
    std::vector<PyWriteBatchEntry>* ops;
} PyWriteBatch;

// custom types
extern PyTypeObject PyLevelDB_Type;
extern PyTypeObject PyLevelDBSnapshot_Type;
extern PyTypeObject PyWriteBatch_Type;
extern PyTypeObject PyLevelDBIter_Type;

#define PyLevelDB_Check(op) PyObject_TypeCheck(op, &PyLevelDB_Type)
#define PyLevelDBSnapshotCheck(op) PyObject_TypeCheck(op, &PyLevelDBSnapshot_Type)
#define PyWriteBatch_Check(op) PyObject_TypeCheck(op, &PyWriteBatch_Type)

extern PyObject* leveldb_exception;

extern const char pyleveldb_repair_db_doc[];
extern const char pyleveldb_destroy_db_doc[];

extern PyObject* pyleveldb_repair_db(PyLevelDB* self, PyObject* args, PyObject* kwds);
extern PyObject* pyleveldb_destroy_db(PyObject* self, PyObject* args);

extern "C" LEVELDB_EXT_API PyObject* PyInit_leveldb_ext(void);
