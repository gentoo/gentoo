# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Utility belt for automated testing in python for python"
HOMEPAGE="https://github.com/gabrielfalcao/sure"
SRC_URI="https://github.com/gabrielfalcao/${PN}/archive/${PV}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

CDEPEND="
	>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
	~dev-python/rednose-0.4.1[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${CDEPEND} )
"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${P}-r1"

python_prepare_all() {
	sed \
		-e "82s/read_version()/'${PV}'/" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -s tests --rednose || die "Tests failed under ${EPYTHON}"
}
