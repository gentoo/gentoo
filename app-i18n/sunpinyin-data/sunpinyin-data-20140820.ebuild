# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DICT_VERSION="20131214"
LM_VERSION="${PV}"

DESCRIPTION="Data sets for Sunpinyin"
HOMEPAGE="https://github.com/sunpinyin/open-gram"
SRC_URI="mirror://sourceforge/open-gram/dict.utf8-${DICT_VERSION}.tar.bz2
	mirror://sourceforge/open-gram/lm_sc.3gm.arpa-${LM_VERSION}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="=app-i18n/sunpinyin-3*"

src_unpack() {
	default
	mkdir "${S}" || die
	mv "${WORKDIR}"/dict.utf8 "${S}" || die
	mv "${WORKDIR}"/lm_sc.3gm.arpa "${S}" || die
}

src_compile() {
	# lm_sc.t3g
	echoit slmpack lm_sc.3gm.arpa dict.utf8 lm_sc.3gm
	echoit slmthread lm_sc.3gm lm_sc.t3g.orig
	echoit tslmendian -i lm_sc.t3g.orig -o lm_sc.t3g
	# lexicon3
	echoit genpyt -i dict.utf8 -s lm_sc.t3g.orig -l pydict_sc.log -o pydict_sc.bin
}

echoit() {
	echo "${@}"
	"${@}"
}

src_install() {
	insinto /usr/share/${PN/-data}
	doins lm_sc.t3g pydict_sc.bin
}
