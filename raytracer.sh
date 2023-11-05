#!/bin/bash
source math.sh

WIDTH=256
HEIGHT=256
DISTANCE=80

MAX_COLOR=255
COLOR_DISTANCE=2

S_X=0
S_Y=0
S_Z=80
S_R=120

# Constant optimization
two_f=$(m_int 2)
four_f=$(m_int 4)

width_f=$(m_int ${WIDTH})
height_f=$(m_int ${HEIGHT})
distance_f=$(m_int ${DISTANCE})

neg_distance=$(m_neg ${distance_f})
sqr_distance=$(m_sqr ${distance_f})

s_x_f=$(m_int ${S_X})
s_y_f=$(m_int ${S_Y})
s_z_f=$(m_int ${S_Z})
s_r_f=$(m_int ${S_R})

function scene {
	local x=$1
	local y=$2
	local z=$3

	local a=$4
	local b=$5
	local c=$6

	# Sphere intersection
	# sx,sy,sz - sphere center, x,y,z - source, a,b,c - dir vector (len = 1)
	# ((sx-x) - at)^2 + ((sy-y) - bt)^2 + ((sz-z) - ct)^2 = r^2
	# (sx-x)^2 - 2(sx-x)at + a^2 t^2 + (sy-y)^2 - 2(sy-y)bt + b^2 t^2 +
	# + (sz-z)^2 - 2(sz-z)ct + c^2 t^2 = r^2
	# t^2 + 2((x-sx)a + (y-sy)b + (z-sz)c)t + ((sx-x)^2 + (sy-y)^2 + (sz-z)^2 - r^2) = 0

	local B=$(m_mul ${two_f} \
			$(m_add $(m_mul $(m_sub ${x} ${s_x_f}) ${a}) \
				$(m_add $(m_mul $(m_sub ${y} ${s_y_f}) ${b}) \
					$(m_mul $(m_sub ${z} ${s_z_f}) ${c}))))
	local C=$(m_add $(m_sqr $(m_sub ${s_x_f} ${x})) \
			$(m_add $(m_sqr $(m_sub ${s_y_f} ${y})) \
				$(m_sub $(m_sqr $(m_sub ${s_z_f} ${z})) \
					$(m_sqr ${s_r_f}))))

	local det=$(m_sub $(m_sqr ${B}) $(m_mul ${four_f} ${C}))
	if ((det <= 0)); then
		echo 0
	else
		local t1=$(m_div $(m_add $(m_neg ${B}) $(m_sqrt ${det})) ${two_f} ${A})
		local t2=$(m_div $(m_sub $(m_neg ${B}) $(m_sqrt ${det})) ${two_f} ${A})
		if ((t1 < t2)); then
			echo ${t1}
		else
			echo ${t2}
		fi
	fi
}

function as_color {
	local distance=$(m_to_int $1)
	if (($1 == 0)); then
		echo "180 0 180"
	else
		local color=$((255 - COLOR_DISTANCE * distance))
		if ((color > 0)); then
			echo "0 0 ${color}"
		else
			echo "180 0 180"
		fi
	fi
}

echo "P3 ${WIDTH} ${HEIGHT} 255"
for ((ypic=0; ypic<HEIGHT; ypic++)); do
	echo ${ypic} 1>&2
	for ((xpic=0; xpic<WIDTH; xpic++)); do
		# Find direction vector for current pixel
		x=$(m_sub $(m_int xpic) $(m_div ${width_f} ${two_f}))
		y=$(m_sub $(m_div ${height_f} ${two_f}) $(m_int ypic))
		
		len=$(m_add $(m_sqr ${x}) $(m_add $(m_sqr ${y}) ${sqr_distance}))
		len=$(m_sqrt ${len})

		a=$(m_div ${x} ${len})
		b=$(m_div ${y} ${len})
		c=$(m_div ${distance_f} ${len})

		# Find intersection with an object of the scene
		t=$(scene 0 0 ${neg_distance} ${a} ${b} ${c})
		as_color ${t}
	done
done
