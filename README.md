# scrl

## intro
Scrl is a simple scripting language/VM implemented in Common Lisp.

```
> (scrl:with-vm () (scrl:repl))
scrl v1

 + 1 2
 
[3]
```

## performance
The VM currently runs around 9x as slow as Python.
`bench` returns the number of milliseconds it takes to run it's body `N` times.

### recursive fibonacci

```
 fun fib (n) 
   if < n 2 n else + fib dec n fib - n 2

 bench 100 fib 20

[712]
```

```
$ python3 fibrec.py 
81
```

### tail recursive fibonacci

```
 fun fib(n a b)
   if > n 1 ret fib dec n b + a b else if z? n a else b

 bench 10000 fib 70 0 1
 
[268]
```

```
$ python3 fibtail.py 
41
```