# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Python modules to work with Debian-related data formats"
HOMEPAGE="https://packages.debian.org/sid/python-debian"
SRC_URI="mirror://debian/pool/main/${P:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( app-arch/dpkg )"

RESTRICT="test"

python_prepare_all() {
	sed -i -e '/import apt_pkg/d' \
		-e 's/test_iter_paragraphs_comments_use_apt_pkg/_&/' \
		lib/debian/tests/test_deb822.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	"${PYTHON}" lib/debian/doc-debtags > README.debtags || die
}

python_test() {
	"${PYTHON}" -m unittest discover lib || die "Testing failed with ${EPYTHON}"
}
