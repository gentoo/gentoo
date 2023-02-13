# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Fuzzy matching library - C++ extension for Python"
HOMEPAGE="https://pypi.org/project/python-tlsh/"
SRC_URI="https://github.com/trendmicro/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${P}/py_ext

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc64 x86"

DEPEND="dev-libs/tlsh"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-setup-sources.patch
)

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e 's:#include "tlsh.h":#include <tlsh/tlsh.h>:' tlshmodule.cpp || die
}

python_test() {
	"${EPYTHON}" test.py test.py test.py &> /dev/null || die
}
