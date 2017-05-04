# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit cmake-utils python-single-r1

DESCRIPTION="Boost.Python interface for NumPy"
HOMEPAGE="https://github.com/ndarray/Boost.NumPy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/ndarray/Boost.NumPy.git \
		https://github.com/ndarray/Boost.NumPy.git"
else
	SRC_URI="https://dev.gentoo.org/~heroxbd/${P}.tar.xz"
fi

LICENSE="Boost-1.0"
SLOT=0
KEYWORDS=""

IUSE="doc examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-libs/boost[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	# Make sure that new Python ABI names are searched too
	sed -i \
		-e 's/PythonLibsNew/PythonLibs/' \
		-e 's/python3/python/' \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install

	use doc && dodoc -r libs/numpy/doc/*
	use examples && dodoc -r libs/numpy/example
}
