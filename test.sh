# Testing library
function assert_eq {
	if [[ "$1" != "$2" ]]; then
		echo "assertion failed: '$1' != '$2'"
		exit 1
	else
		echo "assertion passed: '$1' == '$2'"
	fi
}
