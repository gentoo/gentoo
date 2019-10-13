# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="large set of crack/cracklib dictionaries"
HOMEPAGE="https://github.com/cracklib/cracklib/"
SRC_URI="https://github.com/cracklib/cracklib/releases/download/${P/-words}/${P}.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/dict
	newins ${P} ${PN}
}

pkg_postinst() {
	if [ "${ROOT}" = "/" ] && create-cracklib-dict -h >&/dev/null ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict /usr/share/dict/* >/dev/null
		eend $?
	fi
}
