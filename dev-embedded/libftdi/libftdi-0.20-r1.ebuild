# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit cmake-utils python-single-r1

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://developer.intra2net.com/${PN}"
else
	SRC_URI="http://www.intra2net.com/en/developer/${PN}/download/${P}.tar.gz"
	KEYWORDS="amd64 arm ~arm64 ppc ppc64 sparc x86"
fi

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="cxx doc examples python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="virtual/libusb:0
	cxx? ( dev-libs/boost )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-cmake-include.patch
	"${FILESDIR}"/${P}-cmake-version.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if use python; then
		sed -i \
			-e "s:[$]{PYTHON_LIB_INSTALL}/../site-packages:$(python_get_sitedir):" \
			bindings/CMakeLists.txt || die
	fi
	sed -i \
		-e '/SET(LIB_SUFFIX /d' \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFTDIPP=$(usex cxx)
		-DDOCUMENTATION=$(usex doc)
		-DEXAMPLES=$(usex examples)
		-DPYTHON_BINDINGS=$(usex python)
		-DCMAKE_SKIP_BUILD_RPATH=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize
	dodoc ChangeLog README

	if use doc ; then
		# Clean up crap man pages. #356369
		rm -vf "${CMAKE_BUILD_DIR}"/doc/man/man3/{_,usb_,deprecated}*

		doman "${CMAKE_BUILD_DIR}"/doc/man/man3/*
		dodoc -r "${CMAKE_BUILD_DIR}"/doc/html
	fi
	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi
}
