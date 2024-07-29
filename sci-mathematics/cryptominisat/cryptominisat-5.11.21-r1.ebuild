# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD="ON"

PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_EXT="1"
DISTUTILS_OPTIONAL="1"
DISTUTILS_USE_PEP517="setuptools"

inherit cmake distutils-r1

DESCRIPTION="Advanced SAT solver with C++ and command-line interfaces"
HOMEPAGE="https://github.com/msoos/cryptominisat/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/msoos/${PN}.git"
else
	SRC_URI="https://github.com/msoos/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2 MIT"
SLOT="0/${PV}"
IUSE="python"
RESTRICT="test"                               # Tests require some git modules.
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/tomli[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	python? (
		${DISTUTILS_DEPS}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.11.21-setup-py.patch"
	"${FILESDIR}/${PN}-5.11.21-unistd.patch"
)

src_prepare() {
	cmake_src_prepare

	if use python ; then
		distutils-r1_src_prepare
	fi
}

src_configure() {
	local -a mycmakeargs=(
		-DNOBREAKID=ON
		-DENABLE_TESTING=OFF
	)
	cmake_src_configure

	if use python ; then
		python_setup
	fi
}

src_compile() {
	cmake_src_compile

	if use python ; then
		distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

	if use python ; then
		distutils-r1_src_install
	fi
}
