# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyptlib/pyptlib-0.0.6.ebuild,v 1.3 2015/07/05 14:18:33 blueness Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library for tor's pluggable transport managed-proxy protocol"
HOMEPAGE="https://gitweb.torproject.org/pluggable-transports/pyptlib.git"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="doc examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DOCS=( README.rst TODO )

python_test() {
	"${PYTHON}" -m unittest discover || die "tests failed"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
