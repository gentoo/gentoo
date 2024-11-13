# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

MY_P="${PN}_${PV}"

DESCRIPTION="2-way/3-way merge tool (CLI, Ncurses)"
HOMEPAGE="https://github.com/osamuaoki/imediff"
SRC_URI="mirror://debian/pool/main/i/${PN}/${MY_P}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

distutils_enable_tests unittest

src_test() {
	distutils-r1_src_test
}

python_test() {
	cd test || die
	${EPYTHON} test_unittest_all.py || die
}

src_install() {
	distutils-r1_src_install
	rm "${D}"/usr/bin/imediff_install || die
	python_doscript "${D}"/usr/bin/imediff
	newbin usr/bin/git-ime.in git-ime
	doman usr/share/man/man1/imediff.1 usr/share/man/man1/git-ime.1
}
