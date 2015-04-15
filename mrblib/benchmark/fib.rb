# Fib 39

SIZE = (39 * ARGV[0]).to_i

def fib n
  return n if n < 2
  fib(n-2) + fib(n-1)
end

INV_SQRT5 = 0.44721359549995793928183473374626
PHI       = 1.6180339887498948482045868343656
def _fib n
  (PHI**n * INV_SQRT5 + 0.5).floor.to_i
end

# fib(39) = 63245986
fail unless fib(SIZE) == _fib(SIZE)
SIZE


