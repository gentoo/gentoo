# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sphinxcontrib-cheeseshop/sphinxcontrib-cheeseshop-0.2.ebuild,v 1.1 2014/10/21 02:33:16 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 pypy)

inherit distutils-r1

DESCRIPTION="Sphinx extension cheeseshop"
HOMEPAGE="http://bitbucket.org/birkenfeld/sphinx-contrib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/sphinx-1.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	ebegin 'patching setup.py'
	sed \
		-e '5s/file/open/' \
		-i setup.py
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	distutils-r1_python_prepare_all
}
