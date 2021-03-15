# Copyright 2011-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python modules to work with Debian-related data formats"
HOMEPAGE="https://salsa.debian.org/python-debian-team/python-debian"
SRC_URI="mirror://debian/pool/main/${P:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( app-arch/dpkg )
"

PATCHES=( "${FILESDIR}/0.1.39-disable-apt-pkg.patch" )

python_compile_all() {
	${EPYTHON} lib/debian/doc-debtags > README.debtags || die
}

python_test() {
	${EPYTHON} -m unittest discover --verbose lib || die "Testing failed with ${EPYTHON}"
}
