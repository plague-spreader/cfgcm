#!/bin/bash

SUCCESS=0
INVALID_ARGS=1
INVALID_SCHEME=2
NO_PATH=3
INVALID_PATH=4

function error_no_path() {
	>&2 printf "Url does not have a path\n"
	exit $NO_PATH
}

[ $# -lt 1 ] && {
	>&2 printf "Usage: $0 cfgcm:<path>\n"
	exit $INVALID_ARGS
}

[[ "$1" =~ ^cfgcm:.* ]] || {
	>&2 printf "Url must begin with \"cfgcm:\"\n"
	exit $INVALID_SCHEME
}

url_to_parse="${1#cfgcm:}"

# discard authorities

[[ "$url_to_parse" =~ ^// ]] && {
	url_to_parse=${url_to_parse#//}
	[[ "$url_to_parse" =~ / ]] || error_no_path
	authority=${url_to_parse%%/*} # just keeping this for future uses
	url_to_parse=${url_to_parse#*/}
}

# path extraction

path=$url_to_parse
[[ "$path" =~ ^/ ]] && path=${path:1}

[ "$path" ] || error_no_path

"${XDG_DATA_HOME:-/home/user/.local/share}/cfgcm/$path/connect"

exit $SUCCESS # to avoid opening of x-www-browser
