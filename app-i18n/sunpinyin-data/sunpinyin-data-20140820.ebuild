# Copyright 2013-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit edo

DICT_VERSION="20131214"
LM_VERSION="${PV}"

DESCRIPTION="Data sets for SunPinyin"
HOMEPAGE="https://github.com/sunpinyin/open-gram"
SRC_URI="mirror://sourceforge/open-gram/dict.utf8-${DICT_VERSION}.tar.bz2
	mirror://sourceforge/open-gram/lm_sc.3gm.arpa-${LM_VERSION}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv x86"
IUSE=""

# https://github.com/sunpinyin/sunpinyin/commit/0fff1e78d9a409205e025736286838721a2ccbf8
BDEPEND=">=app-i18n/sunpinyin-2.0.4_pre20140819192400"
DEPEND=""
RDEPEND=""

src_unpack() {
	default
	mkdir "${S}" || die
	mv "${WORKDIR}"/dict.utf8 "${S}" || die
	mv "${WORKDIR}"/lm_sc.3gm.arpa "${S}" || die
}

src_compile() {
	# lm_sc.t3g
	edo slmpack lm_sc.3gm.arpa dict.utf8 lm_sc.3gm
	edo slmthread lm_sc.3gm lm_sc.t3g.orig
	edo tslmendian -i lm_sc.t3g.orig -o lm_sc.t3g
	# lexicon3
	edo genpyt -i dict.utf8 -s lm_sc.t3g.orig -l pydict_sc.log -o pydict_sc.bin
}

src_install() {
	insinto /usr/share/${PN/-data}
	doins lm_sc.t3g pydict_sc.bin
}
