# Fixed-point arithmetic library
PRECISION=${PRECISION:-4}
SQRT_PRECISION=${SQRT_PRECISION:-10}

multiplier=$((10 ** PRECISION))
postfix=$(for ((i=0; i<PRECISION; i++)); do echo -n 0; done)

# Conversion functions
function m_int {
	echo $(($1 * multiplier))
}

function m_float {
	local fractional=${2}${postfix}
	fractional=${fractional:0:PRECISION}
	echo $(($1 * multiplier + ($1 >= 0 ? 1 : -1) * fractional)) 
}

function m_to_int {
	echo $(($1 / multiplier))
}

# Basic arithmetic
function m_neg {
	echo $((0 - $1))
}

function m_abs {
	echo $(($1 >= 0 ? $1 : -$1))
}

function m_add {
	echo $(($1 + $2))
}

function m_sub {
	echo $(($1 - $2))
}

function m_mul {
	echo $(($1 * $2 / multiplier))
}

function m_div {
	echo $(($1 * multiplier / $2))
}

# Compound functions
function m_sqr {
	echo $(m_mul $1 $1)
}

function m_sqrt {
	# Babylonian method
	local x=$1
	while true; do
		local next_x=$(m_mul $(m_float 0 5) $(m_add ${x} $(m_div $1 ${x})))
		local delta=$(m_abs $(m_sub ${x} ${next_x}))
		if ((delta < SQRT_PRECISION)); then
			break
		fi
		x=${next_x}
	done
	echo $x
}
