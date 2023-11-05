#!/bin/bash
source math.sh
source test.sh

# Conversion functions
assert_eq $(m_int 5) 50000
assert_eq $(m_int -5) -50000
assert_eq $(m_int 0) 0

assert_eq $(m_float 4 5) 45000
assert_eq $(m_float -2 3) -23000
assert_eq $(m_float 1 23456) 12345
assert_eq $(m_float 0 2) 2000
assert_eq $(m_float 0 0) 0

assert_eq $(m_to_int 12345) 1
assert_eq $(m_to_int 16543) 1 # TODO
assert_eq $(m_to_int -12345) -1
assert_eq $(m_to_int -16543) -1 # TODO

# Basic arithmetic
assert_eq $(m_neg $(m_int 3)) $(m_int -3)
assert_eq $(m_neg $(m_float 0 2)) -2000
assert_eq $(m_neg $(m_int -3)) $(m_int 3)
assert_eq $(m_neg -2000) $(m_float 0 2)
assert_eq $(m_neg $(m_int 0)) 0

assert_eq $(m_abs $(m_int 1)) $(m_int 1)
assert_eq $(m_abs $(m_int 0)) $(m_int 0)
assert_eq $(m_abs $(m_int -1)) $(m_int 1)

assert_eq $(m_add $(m_float 4 5) $(m_float 0 2)) $(m_float 4 7)
assert_eq $(m_add $(m_float 1 5) $(m_int -3)) $(m_float -1 5)
assert_eq $(m_add $(m_float 3 1) $(m_float -3 1)) 0

assert_eq $(m_sub $(m_float 4 5) $(m_float 0 3)) $(m_float 4 2)
assert_eq $(m_sub $(m_float 0 2) $(m_float 0 5)) $(m_neg $(m_float 0 3))
assert_eq $(m_sub $(m_float 1 5) $(m_float -1 5)) $(m_int 3)

assert_eq $(m_mul $(m_int 2) $(m_int 3)) $(m_int 6)
assert_eq $(m_mul $(m_int 2) $(m_float -2 3)) $(m_float -4 6)
assert_eq $(m_mul $(m_int -2) $(m_int -2)) $(m_int 4)
assert_eq $(m_mul $(m_int 0) $(m_float 2)) $(m_int 0)

assert_eq $(m_div $(m_int 4) $(m_int 2)) $(m_int 2)
assert_eq $(m_div $(m_int 5) $(m_int 2)) $(m_float 2 5)
assert_eq $(m_div $(m_float 1 2345) $(m_float 6 789)) $(m_float 0 1818)

# Compound functions
assert_eq $(m_sqr $(m_float 2 2)) $(m_float 4 84)
assert_eq $(m_sqr $(m_int -2)) $(m_int 4)

assert_eq $(m_sqrt $(m_int 4)) $(m_int 2)
assert_eq $(m_sqrt $(m_float 1 2345)) $(m_float 1 1110)

echo "all tests passed"
