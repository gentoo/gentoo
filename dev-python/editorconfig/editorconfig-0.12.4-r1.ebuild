# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake distutils-r1

MY_P=editorconfig-core-py-${PV}
TESTVER="abb579e00f2deeede91cb485e53512efab9c6474"
DESCRIPTION="Clone of EditorConfig core written in Python"
HOMEPAGE="https://editorconfig.org/"
SRC_URI="
	https://github.com/editorconfig/editorconfig-core-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	test? (
		https://github.com/editorconfig/editorconfig-core-test/archive/${TESTVER}.tar.gz
			-> editorconfig-core-test-${TESTVER}.gh.tar.gz
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="PYTHON BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli test"
RESTRICT="!test? ( test )"

RDEPEND="
	cli? ( !app-text/editorconfig-core-c[cli] )
"

src_prepare() {
	if use test; then
		mv "${WORKDIR}"/editorconfig-core-test-${TESTVER}/* "${S}"/tests || die
	fi
	if ! use cli; then
		sed -i -e '/editorconfig\.__main__/d' setup.cfg || die
	fi

	cmake_src_prepare
	distutils-r1_src_prepare
}

python_test() {
	cmake_src_configure
	cmake_src_compile
	cmake_src_test
}
