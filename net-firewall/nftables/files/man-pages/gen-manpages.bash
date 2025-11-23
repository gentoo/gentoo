#!/bin/bash
#
# create manpages for nftables

declare -A MAN_PAGES

MAN_PAGES=(
	[nft.8]="nft.txt"
	[libnftables-json.5]="libnftables-json.adoc"
	[libnftables.3]="libnftables.adoc"
)

build_manpages() {
	tar axf "${distfile}" -C "${srcdir}" || return

	pushd "${srcdir}/${version}/doc" > /dev/null || return
	local manpage
	for manpage in "${!MAN_PAGES[@]}"; do
		a2x -L --doctype manpage --format manpage -D . "${MAN_PAGES[${manpage}]}" || return
	done
	popd > /dev/null || return

	local -a tarfiles
	readarray -t tarfiles < <(printf -- "${version}/doc/%s\\n" "${!MAN_PAGES[@]}")

	tar -Jc --owner='root:0' --group='root:0' \
		--transform="s:^${version}/doc:${version}-manpages:" \
		-f "${version}-manpages.tar.xz" \
		-C "${srcdir}" \
		"${tarfiles[@]}" || return

	rm -rf "${srcdir:?}/${version}" || return
}

main() {
	shopt -s failglob
	local version="${1}" srcdir="${0%/*}"

	if [[ -z ${version} ]]; then
		# shellcheck disable=SC2016
		version=$(
			find . -maxdepth 1 -type d -a -name 'nftables-*' -printf '%P\0' 2>/dev/null \
			| LC_COLLATE=C sort -z \
			| sed -z -n '${p;Q}' \
			| tr -d '\000'
		)
		if [[ -z ${version} ]]; then
			# shellcheck disable=SC2016
			version=$(
				find . -maxdepth 3 -mindepth 3 -type f -a -name 'nftables-*.ebuild' -printf '%P\0' 2>/dev/null \
				| LC_COLLATE=C sort -z \
				| sed -r -z -n '${s:.*/::;s:-r[0-9]+::;s:[.]ebuild::;p;Q}' \
				| tr -d '\000'
			)
			if [[ -z ${version} ]]; then
				printf 'Usage %s <version>\n' "${0}" >&2
				return 1
			fi
		fi
	elif [[ ${version} =~ [0-9.]+ ]]; then
		version="nftables-${version}"
	fi

	local distdir distfile
	local -a distfiles
	distdir="$(portageq distdir)" || return
	distfiles=( "${distdir}/${version}.tar."* ) || return
	distfile="${distfiles[-1]}"
	build_manpages || return
}

main "${@}"
