# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs

DESCRIPTION="Syzygy chess endgame tablebases for up to 6 pieces"
HOMEPAGE="http://tablebase.sesse.net/
	https://kirill-kryukov.com/chess/tablebases-online/"

tb345=()
tb6=()
m=(P N B R Q K)
for ((i=4; i>=0; i--)); do
	tb345+=(K${m[i]}vK) # 2+1
	for ((j=i; j>=0; j--)); do
		tb345+=(K${m[i]}vK${m[j]} K${m[i]}${m[j]}vK) # 2+2, 3+1
		for ((k=4; k>=0; k--)); do
			tb345+=(K${m[i]}${m[j]}vK${m[k]}) # 3+2
			((k<=i)) || continue
			for ((l=k; l>=0; l--)); do
				((k<i || l<=j)) && tb6+=(K${m[i]}${m[j]}vK${m[k]}${m[l]}) # 3+3
			done
			((k<=j)) || continue
			tb345+=(K${m[i]}${m[j]}${m[k]}vK) # 4+1
			for ((l=4; l>=0; l--)); do
				tb6+=(K${m[i]}${m[j]}${m[k]}vK${m[l]}) # 4+2
				((l<=k)) && tb6+=(K${m[i]}${m[j]}${m[k]}${m[l]}vK) # 5+1
			done
		done
	done
done

tb345=("${tb345[@]/#/mirror+http://tablebase.sesse.net/syzygy/3-4-5/}")
SRC_URI="${tb345[@]/%/.rtbw} ${tb345[@]/%/.rtbz}
	6-pieces? ( ${tb6[@]/%/.rtbw} ${tb6[@]/%/.rtbz} )"
unset i j k l m tb345 tb6

LICENSE="public-domain" # machine-generated tables
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="6-pieces"
RESTRICT="fetch"

RDEPEND="!${CATEGORY}/${PN}:nofetch"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Due to their large size, fetching the Syzygy Endgame Tablebases via"
	einfo "BitTorrent is recommended: https://oics.olympuschess.com/tracker/"
	einfo "After downloading, place all K*.rtbw and K*.rtbz files in your"
	einfo "DISTDIR directory."
	einfo "(For the tablebases with up to 6 pieces, there should be"
	einfo "$(set -- ${A}; echo $#) files in total.)"
}

pkg_pretend() {
	CHECKREQS_DISK_USR="$(usex 6-pieces 151G 939M)"
	CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"
	check-reqs_pkg_pretend
}

pkg_setup() {
	CHECKREQS_DISK_USR="$(usex 6-pieces 151G 939M)"
	CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"
	check-reqs_pkg_setup
}

src_unpack() { :; }

src_install() {
	local f
	insinto /usr/share/${PN}
	for f in ${A}; do
		[[ ${f} == *.rtb[wz] ]] && echo "${DISTDIR}"/${f}
	done | xargs doins
}
