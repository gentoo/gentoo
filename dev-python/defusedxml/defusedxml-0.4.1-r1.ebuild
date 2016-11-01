# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="XML bomb protection for Python stdlib modules, an xml serialiser"
HOMEPAGE="https://bitbucket.org/tiran/defusedxml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="examples"

LICENSE="PSF-2"
SLOT="0"

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( other/. )
	distutils-r1_python_install_all
}
