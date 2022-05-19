# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_PN=python-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python library for the snappy compression library from Google"
HOMEPAGE="
	https://github.com/andrix/python-snappy/
	https://pypi.org/project/python-snappy/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
KEYWORDS="amd64 arm arm64 ~riscv x86 ~amd64-linux ~x86-linux"
SLOT="0"

DEPEND="
	>=app-arch/snappy-1.0.2:=
"
RDEPEND="
	${DEPEND}
"

python_test() {
	cp test*.py "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	"${EPYTHON}" -m unittest -v || die "Tests fail with ${EPYTHON}"
}
