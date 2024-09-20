# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake python-single-r1

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://developer.intra2net.com/${PN}"
else
	SRC_URI="https://www.intra2net.com/en/developer/${PN}/download/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="https://www.intra2net.com/en/developer/libftdi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="cxx doc examples python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	virtual/libusb:0
	cxx? ( dev-libs/boost )
	doc? ( !dev-embedded/libftdi:1[doc] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
	python? ( >=dev-lang/swig-4.2.0 )
"

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

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFTDIPP=$(usex cxx)
		-DDOCUMENTATION=$(usex doc)
		-DEXAMPLES=$(usex examples)
		-DPYTHON_BINDINGS=$(usex python)
		-DCMAKE_SKIP_BUILD_RPATH=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	use python && python_optimize
	dodoc ChangeLog README

	if use doc ; then
		# Clean up man pages with too generic names. #356369
		rm -vf "${BUILD_DIR}"/doc/man/man3/{_,usb_,deprecated}* || die

		doman "${BUILD_DIR}"/doc/man/man3/*
		dodoc -r "${BUILD_DIR}"/doc/html
	fi

	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi

	use static-libs || rm "${ED}"/usr/$(get_libdir)/${PN}.a || die
}
