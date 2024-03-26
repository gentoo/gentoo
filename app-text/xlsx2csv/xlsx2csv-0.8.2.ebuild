# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Convert MS Office xlsx files to CSV"
HOMEPAGE="https://github.com/dilshod/xlsx2csv/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-lang/perl"

PATCHES=( "${FILESDIR}"/"${PN}-0.7.8-tests.patch" )

python_compile_all() {
	emake -C man
}

python_test() {
	"${EPYTHON}" test/run || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	doman "man/${PN}.1"
}
