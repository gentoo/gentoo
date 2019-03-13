# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs

DESCRIPTION="Syzygy chess endgame tablebases for up to 6 pieces"
HOMEPAGE="http://tablebase.sesse.net/
	http://kirill-kryukov.com/chess/tablebases-online/"

tb345=()
m=(P N B R Q K)
for ((i=4; i>=0; i--)); do
	tb345+=(K${m[i]}vK) # 2+1
	for ((j=i; j>=0; j--)); do
		tb345+=(K${m[i]}vK${m[j]} K${m[i]}${m[j]}vK) # 2+2, 3+1
		for ((k=4; k>=0; k--)); do
			tb345+=(K${m[i]}${m[j]}vK${m[k]}) # 3+2
			#((k<=i)) || continue
			#for ((l=k; l>=0; l--)); do
			#	((k<i || l<=j)) && tb6+=(K${m[i]}${m[j]}vK${m[k]}${m[l]}) # 3+3
			#done
			((k<=j)) || continue
			tb345+=(K${m[i]}${m[j]}${m[k]}vK) # 4+1
			#for ((l=4; l>=0; l--)); do
			#	tb6+=(K${m[i]}${m[j]}${m[k]}vK${m[l]}) # 4+2
			#	((l<=k)) && tb6+=(K${m[i]}${m[j]}${m[k]}${m[l]}vK) # 5+1
			#done
		done
	done
done

SRC_URI=""
for i in "${tb345[@]}"; do
	SRC_URI+="http://tablebase.sesse.net/syzygy/3-4-5/${i}.rtbw "
	SRC_URI+="http://tablebase.sesse.net/syzygy/3-4-5/${i}.rtbz "
done
unset i j k m tb345

LICENSE="public-domain" # machine-generated tables
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="6-pieces"

# there is no use-conditional mirror restriction,
# so depend on another slot of the same package instead
PDEPEND="6-pieces? ( ~${CATEGORY}/${P}:nofetch )"

S="${WORKDIR}"
CHECKREQS_DISK_USR="939M"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"

src_unpack() { :; }

src_install() {
	local f
	insinto /usr/share/${PN}
	for f in ${A}; do
		[[ ${f} = *.rtb[wz] ]] && echo "${DISTDIR}"/${f}
	done | xargs doins
}
