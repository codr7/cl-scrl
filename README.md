# scrl

## intro
Scrl is a simple scripting language/VM implemented in Common Lisp.

```
> (scrl:with-vm () (scrl:repl))
scrl v1

 + 1 2
 
[3]
```

### performance
`bench` returns the number of milliseconds it takes to run it's body `N` times.

#### recursive fibonacci

```
 fun fib (n) 
   if < n 2 n else + fib - n 1 fib - n 2

 bench 100 fib 20

[764]
```

#### tail recursive fibonacci

```
 fun fib(n a b)
   if > n 1 fib - n 1 b + a b else if = n 0 a else b

 bench 10000 fib 70 0 1
 
[310]
```