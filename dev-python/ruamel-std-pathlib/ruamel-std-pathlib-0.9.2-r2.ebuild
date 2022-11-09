# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_P="${PN//-/.}-${PV}"
DESCRIPTION="Ruamel enhancements to pathlib and pathlib2"
HOMEPAGE="
	https://pypi.org/project/ruamel.std.pathlib/
	https://sourceforge.net/projects/ruamel-std-pathlib/
"
# PyPI tarballs do not include tests
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz -> ${P}.tar.xz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	!dev-python/namespace-ruamel
"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	distutils_write_namespace ruamel
	epytest
}
