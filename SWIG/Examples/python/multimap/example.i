/* File : example.i */
%module example
%include exception.i

extern int    gcd(int x, int y);

%typemap(python,in) (int argc, char *argv[]) {
  int i;
  if (!PyList_Check($source)) {
    SWIG_exception(SWIG_ValueError, "Expecting a list");
    return NULL;
  }
  $0.target = PyList_Size($source);
  if ($0.target == 0) {
    SWIG_exception(SWIG_ValueError, "List must contain at least 1 element");
    return NULL;
  }
  $1.target = (char **) malloc(($0.target+1)*sizeof(char *));
  for (i = 0; i < $0.target; i++) {
    PyObject *s = PyList_GetItem($source,i);
    if (!PyString_Check(s)) {
      SWIG_exception(SWIG_ValueError, "List items must be strings");
      free($1.target);
      return NULL;
    }
    $1.target[i] = PyString_AsString(s);
  }
  $1.target[i] = 0;
}

extern int gcdmain(int argc, char *argv[]);

%typemap(python,in) (char *bytes, int len) {
  if (!PyString_Check($source)) {
    PyErr_SetString(PyExc_ValueError,"Expected a string");
    return NULL;
  }
  $0.target = PyString_AsString($source);
  $1.target = PyString_Size($source);
}

extern int count(char *bytes, int len, char c);

