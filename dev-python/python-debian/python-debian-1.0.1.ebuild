# Copyright 2011-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python modules to work with Debian-related data formats"
HOMEPAGE="
	https://salsa.debian.org/python-debian-team/python-debian/
	https://pypi.org/project/python-debian/
"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

RDEPEND="
	dev-python/charset-normalizer[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		app-arch/dpkg
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# silence false positives
	rm -rf debian || die
}

python_compile_all() {
	# See debian/rules.
	"${EPYTHON}" src/debian/doc-debtags > README.debtags || die
}

python_test() {
	epytest --doctest-modules
}
