# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=tlsh-${PV}
DESCRIPTION="Fuzzy matching library - C++ extension for Python"
HOMEPAGE="
	https://github.com/trendmicro/tlsh/
	https://pypi.org/project/python-tlsh/
"
SRC_URI="
	https://github.com/trendmicro/tlsh/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}/py_ext

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

DEPEND="dev-libs/tlsh"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-setup-sources.patch
	"${FILESDIR}"/${P}-r1-py312.patch
)

python_test() {
	../Testing/python_test.sh "${EPYTHON}" || die
}
