# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python modules to work with Debian-related data formats"
HOMEPAGE="https://packages.debian.org/sid/python-debian"
SRC_URI="mirror://debian/pool/main/${P:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		app-arch/dpkg
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' -2)
	)
"

PATCHES=( "${FILESDIR}/0.1.36-disable-apt-pkg.patch" )

python_compile_all() {
	${EPYTHON} lib/debian/doc-debtags > README.debtags || die
}

python_test() {
	${EPYTHON} -m unittest discover --verbose lib || die "Testing failed with ${EPYTHON}"
}
