# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} )

inherit python-single-r1

DESCRIPTION="Tool for community verification of Gentoo elections"
HOMEPAGE="https://github.com/mgorny/votrify"
SRC_URI="https://github.com/mgorny/votrify/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-misc/gentoo-elections"

src_configure() {
	# update default location for election scripts
	sed -i -e "s^os.path.dirname(__file__)^'${EPREFIX}/usr/lib'^" \
		make-confirmation.py || die

	# update script names
	sed -i -e 's:\(./\)\?\(make-confirmation\|verify-confirmations\).py:votrify-\2:g' \
		README.rst || die

	python_fix_shebang *.py
}

src_install() {
	newbin make-confirmation.py votrify-make-confirmation
	newbin verify-confirmations.py votrify-verify-confirmations
	einstalldocs
}
