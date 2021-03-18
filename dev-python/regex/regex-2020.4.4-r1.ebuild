# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Alternative regular expression module to replace re"
HOMEPAGE="https://bitbucket.org/mrabarnett/mrab-regex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-macos"
IUSE="doc"

python_test() {
	distutils_install_for_testing

	pushd "${BUILD_DIR}/lib" > /dev/null || die
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/Features.html )
	local DOCS=( README.rst docs/*.rst )

	distutils-r1_python_install_all
}
