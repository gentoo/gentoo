# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/lightblue/lightblue-0.4-r1.ebuild,v 1.5 2015/03/08 23:37:42 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )
inherit distutils-r1

DESCRIPTION="Cross-platform Bluetooth API for Python which provides simple access to Bluetooth operations"
HOMEPAGE="http://lightblue.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND="
	>=dev-libs/openobex-1.3
	>=dev-python/pybluez-0.9[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
