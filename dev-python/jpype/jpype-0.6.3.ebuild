# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit java-pkg-2 distutils-r1

DESCRIPTION="JPype is an effort to allow Python programs full access to Java class librairies"
HOMEPAGE="https://github.com/originell/jpype"
SRC_URI="https://github.com/originell/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

S="${WORKDIR}/${P}"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=virtual/jdk-1.6"

#PATCHES=( "${FILESDIR}"/${PN}-gcc6-noexcept.patch )

python_install() {
	use doc && local DOCS=( doc/* )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install
}
