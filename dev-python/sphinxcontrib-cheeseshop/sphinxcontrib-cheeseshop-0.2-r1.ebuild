# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy)

inherit distutils-r1

DESCRIPTION="Sphinx extension cheeseshop"
HOMEPAGE="https://bitbucket.org/birkenfeld/sphinx-contrib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/sphinx-1.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed \
		-e '5s/file/open/' \
		-i setup.py || die

	distutils-r1_python_prepare_all
}
