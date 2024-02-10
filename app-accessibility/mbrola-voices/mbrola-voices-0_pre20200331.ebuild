# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GIT_COMMIT=fe05a0ccef6a941207fd6aaad0b31294a1f93a51

DESCRIPTION="mbrola speech synthesizer voices database"
HOMEPAGE="https://github.com/numediart/mbrola-voices"
SRC_URI="https://github.com/numediart/mbrola-voices/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MBROLA-VOICES"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"

# This maps the l10n values to the appropriate voices
declare -A voicemap
voicemap=(
	[af]="af1"
	[ar]="ar1 ar2"
	[br]="bz1"
[cs]="cz1 cz2"
	[de]="de1 de2 de3 de4 de5 de6 de7 de8"
	[el]="gr1 gr2"
	[en-GB]="en1"
	[en-US]="mx1 us1 us2 us3"
	[es]="es1 es2 es3 es4 vz1"
	[es-MX]="mx2"
[et]="ee1"
	[fa]="ir1"
	[fr-CA]="ca1 ca2"
	[fr]="fr1 fr2 fr3 fr4 fr5 fr6 fr7"
	[he]="hb1 hb2"
	[hi]="in1 in2"
	[hr]="cr1"
	[hu]="hu1"
	[id]="id1"
	[is]="ic1"
	[it]="it1 it2 it3 it4"
	[ja]="jp1 jp2 jp3"
	[ko]="hn1"
	[la]="la1"
[lt]="lt1 lt2"
	[mi]="nz1"
	[ms]="ma1"
	[nl]="nl1 nl2 nl3"
	[pl]="pl1"
	[pt-BR]="br1 br2 br3 br4"
	[pt-PT]="pt1"
	[ro]="ro1"
	[sv]="sw1 sw2"
	[te]="tl1"
	[tr]="tr1 tr2"
	[zh-CN]="cn1"
)
for l in "${!voicemap[@]}"; do
	if [[ ${l} == en-US ]]; then
		u="+l10n_${l}"
	else
		u="l10n_${l}"
	fi
	IUSE+=" ${u}"
done
unset l u

S=${WORKDIR}/MBROLA-voices-${GIT_COMMIT}

src_install() {
	dodoc README.md
	insinto /usr/share/mbrola
	cd data || die
	local l
	for l in "${!voicemap[@]}"; do
	use l10n_${l} && doins -r ${voicemap[${l}]}
	done
}
