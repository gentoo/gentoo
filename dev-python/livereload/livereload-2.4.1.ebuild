# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python LiveReload is an awesome tool for web developers"
HOMEPAGE="https://github.com/lepture/python-livereload"
SRC_URI="https://github.com/lepture/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples test"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

RDEPEND="
	${CDEPEND}
	dev-python/six[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"

python_test() {
	nosetests || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( example/. )

	distutils-r1_python_install_all
}
