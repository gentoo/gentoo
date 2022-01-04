# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Ruamel enhancements to pathlib and pathlib2"
HOMEPAGE="https://pypi.org/project/ruamel.std.pathlib/ https://sourceforge.net/p/ruamel-std-pathlib/"
# PyPI tarballs do not include tests
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz -> ${P}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="dev-python/namespace-ruamel[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_install() {
	distutils-r1_python_install --single-version-externally-managed
	find "${ED}" -name '*.pth' -delete || die
}
