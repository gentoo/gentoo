# Copyright 2011-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python modules to work with Debian-related data formats"
HOMEPAGE="
	https://salsa.debian.org/python-debian-team/python-debian/
	https://pypi.org/project/python-debian/
"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		app-arch/dpkg
	)
"

distutils_enable_tests unittest

python_prepare_all() {
	# See debian/rules.
	sed -e "s/__CHANGELOG_VERSION__/${PV}/" lib/debian/_version.py.in \
		> lib/debian/_version.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# See debian/rules.
	"${EPYTHON}" lib/debian/doc-debtags > README.debtags || die
}

python_test() {
	eunittest lib
}
