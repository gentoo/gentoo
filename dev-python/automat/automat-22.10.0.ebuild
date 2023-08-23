# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Self-service finite-state machines for the programmer on the go"
HOMEPAGE="
	https://github.com/glyph/automat/
	https://pypi.org/project/Automat/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="examples"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	benchmark
)

python_install_all() {
	if use examples; then
		docinto examples
		dodoc docs/examples/*.py
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	einfo "For additional visualization functionality install both these optional dependencies"
	einfo "    >=dev-python/twisted-16.1.1"
	einfo "    media-gfx/graphviz[python]"
}
