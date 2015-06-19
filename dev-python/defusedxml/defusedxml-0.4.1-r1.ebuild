# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/defusedxml/defusedxml-0.4.1-r1.ebuild,v 1.8 2015/06/07 09:17:55 maekke Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="XML bomb protection for Python stdlib modules, an xml serialiser"
HOMEPAGE="https://bitbucket.org/tiran/defusedxml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="alpha amd64 arm hppa ~ppc64 x86"
IUSE="examples"

LICENSE="PSF-2"
SLOT="0"

python_test() {
	esetup.py test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( other/. )
	distutils-r1_python_install_all
}
