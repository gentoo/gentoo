# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="
	https://github.com/netaddr/netaddr/
	https://pypi.org/project/netaddr/
	https://netaddr.readthedocs.io/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="cli"

RDEPEND="
	cli? ( dev-python/ipython[${PYTHON_USEDEP}] )
"

distutils_enable_sphinx docs/source \
	dev-python/furo \
	dev-python/sphinx-issues
distutils_enable_tests pytest

src_prepare() {
	if ! use cli; then
		sed -i -e '/netaddr\.cli/d' pyproject.toml || die
	fi

	distutils-r1_src_prepare
}
