# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit java-pkg-2 distutils-r1

DESCRIPTION="JPype is an effort to allow Python programs full access to Java class libraries"
HOMEPAGE="https://github.com/originell/jpype"
SRC_URI="https://github.com/originell/${PN}/archive/v${PV}.zip -> ${P}.zip"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

S="${WORKDIR}/${P}"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=virtual/jdk-1.6"

python_compile() {
	if ! python_is_python3; then
		local CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
		export CXXFLAGS
	fi
	distutils-r1_python_compile
}

python_install() {
	use doc && local DOCS=( doc/* )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install
}
