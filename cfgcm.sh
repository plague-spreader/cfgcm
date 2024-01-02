#!/bin/sh

SUCCESS=0
INVALID_ARGS=1
INVALID_SCHEME=2
NO_PATH=3
INVALID_PATH=4

CFG_CM="${XDG_DATA_HOME:-$HOME/.local/share}/cfgcm/"
CFGCM_SORT_CMD="${CFGCM_SORT_CMD:-cat}"

error_no_path() {
	>&2 printf "Url does not have a path\n"
	exit $NO_PATH
}

parse_description() {
	cat $1
}

select_cfgcm_url() {
	find ${CFG_CM} -type f -iwholename '*/connect' |
		sed -e 's:^.*/cfgcm/::g; s:/connect$::g' |
		while read cfgcm_url; do
			desc_url="${CFG_CM}${cfgcm_url}/description"
			if [ -f "${desc_url}" ]; then
				printf "${cfgcm_url}\t$(parse_description "$desc_url")\n"
			else
				printf "${cfgcm_url}\t${cfgcm_url}\n"
			fi
		done |
		$CFGCM_SORT_CMD |
		fzf -d '\t' --with-nth=2.. |
		cut -d$'\t' -f1
}

url_to_parse="$1"
[ "$url_to_parse" ] || {
	url_to_parse=$(select_cfgcm_url) || exit $SUCCESS
	url_to_parse="cfgcm:./$url_to_parse"
}

[[ "$url_to_parse" =~ ^cfgcm:.* ]] || {
	>&2 printf "Url must begin with \"cfgcm:\"\n"
	exit $INVALID_SCHEME
}

url_to_parse="${url_to_parse#cfgcm:}"

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

"${XDG_DATA_HOME:-$HOME/.local/share}/cfgcm/$path/connect"

exit $SUCCESS # to avoid opening of x-www-browser
