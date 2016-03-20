# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_4 python3_5 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Simple pytest plugin to look for regex in Exceptions"
HOMEPAGE="https://github.com/Walkman/pytest_raisesregexp"
SRC_URI="https://github.com/kissgyorgy/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${CDEPEND} )
"
RDEPEND="
	${CDEPEND}
	dev-python/py[${PYTHON_USEDEP}]
"

python_test() {
	distutils_install_for_testing
	${PYTHON} -m pytest || die "Tests failed under ${EPYTHON}"
}
