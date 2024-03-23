# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py3.12 blocked by wxpython
PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A free, open-source tool for programming your radio"
HOMEPAGE="https://chirp.danplanet.com/"
SRC_URI="https://trac.chirp.danplanet.com/${PN}_next/next-${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+gui radioreference"

RDEPEND="$(python_gen_cond_dep '
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	gui? (
		dev-python/wxpython:4.0[${PYTHON_USEDEP}]
		dev-python/yattag[${PYTHON_USEDEP}]
	)
	radioreference? ( dev-python/suds-community[${PYTHON_USEDEP}] )
')"
BDEPEND="test? ( $(python_gen_cond_dep '
	dev-python/pytest-xdist[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
') )"

PATCHES=(
	"${FILESDIR}"/${PN}-20230818_no-future.patch
)

distutils_enable_tests pytest

# The alias map is an internal developer file not included in release tarballs.
# Other disabled tests require Internet access.
EPYTEST_DESELECT=(
	tests/unit/test_directory.py::TestAliasMap
	tests/unit/test_network_sources.py
	tests/unit/test_repeaterbook.py
)

python_test() {
	# From the contents of tests/ upstream currently only runs unit and driver
	# tests, and the latter can take so long that they have even got a special
	# script for only running them on drivers whose code has changed
	# with respect to origin/master.
	epytest tests/unit/
}

src_install() {
	distutils-r1_src_install
	if ! use gui; then
		rm "${ED}"/usr/bin/${PN} || die
	fi
}
