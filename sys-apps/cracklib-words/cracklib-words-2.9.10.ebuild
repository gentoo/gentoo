# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: ideally bump with sys-libs/cracklib
DESCRIPTION="Large set of crack/cracklib dictionaries"
HOMEPAGE="https://github.com/cracklib/cracklib/"
SRC_URI="https://github.com/cracklib/cracklib/releases/download/v${PV}/${P}.gz"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

src_install() {
	insinto /usr/share/dict
	newins ${P} ${PN}
}

pkg_postinst() {
	if [[ -n ${ROOT} ]] && create-cracklib-dict -h >&/dev/null ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict /usr/share/dict/* >/dev/null
		eend $?
	fi
}
