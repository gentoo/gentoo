# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs

DESCRIPTION="Syzygy chess endgame tablebases for up to 6 pieces"
HOMEPAGE="http://tablebase.sesse.net/
	http://kirill-kryukov.com/chess/tablebases-online/"

tb6=()
m=(P N B R Q K)
for ((i=4; i>=0; i--)); do
	for ((j=i; j>=0; j--)); do
		for ((k=i; k>=0; k--)); do
			for ((l=k; l>=0; l--)); do
				((k<i || l<=j)) && tb6+=(K${m[i]}${m[j]}vK${m[k]}${m[l]}) # 3+3
			done
			((k<=j)) || continue
			for ((l=4; l>=0; l--)); do
				tb6+=(K${m[i]}${m[j]}${m[k]}vK${m[l]}) # 4+2
				((l<=k)) && tb6+=(K${m[i]}${m[j]}${m[k]}${m[l]}vK) # 5+1
			done
		done
	done
done

SRC_URI=""
for i in "${tb6[@]}"; do
	SRC_URI+="${i}.rtbw ${i}.rtbz "
done
unset i j k l m tb6

LICENSE="public-domain" # machine-generated tables
SLOT="nofetch"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch"

RDEPEND="~${CATEGORY}/${P}:0"

S="${WORKDIR}"
CHECKREQS_DISK_USR="150G"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"

pkg_nofetch() {
	einfo "Due to their large size, fetching the Syzygy Endgame Tablebases"
	einfo "via BitTorrent is recommended: http://oics.olympuschess.com/tracker/"
	einfo "After downloading, place all K*.rtbw and K*.rtbz files in"
	einfo "${DISTDIR}."
	einfo "(For the 6-pieces tablebases, there should be" \
		  "$(echo ${A} | wc -w) files in total.)"
}

src_unpack() { :; }

src_install() {
	local f
	insinto /usr/share/${PN}
	for f in ${A}; do
		[[ ${f} = *.rtb[wz] ]] && echo "${DISTDIR}"/${f}
	done | xargs doins
}
