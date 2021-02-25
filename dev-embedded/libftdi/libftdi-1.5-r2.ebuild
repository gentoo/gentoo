# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit cmake python-single-r1

MY_P="${PN}1-${PV}"
if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://developer.intra2net.com/${PN}"
else
	SRC_URI="https://www.intra2net.com/en/developer/${PN}/download/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 arm ~arm64 ~mips ppc ppc64 ~sparc ~x86"
fi

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="https://www.intra2net.com/en/developer/libftdi/"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2"
SLOT="1"
IUSE="cxx doc examples python test tools"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig )"
RDEPEND="
	virtual/libusb:1
	cxx? ( dev-libs/boost )
	python? ( ${PYTHON_DEPS} )
	tools? (
		!<dev-embedded/ftdi_eeprom-1.0
		dev-libs/confuse:=
	)"
DEPEND="${RDEPEND}
	test? ( dev-libs/boost )
"

PATCHES=( "${FILESDIR}"/${P}-tests-no-cxx.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DFTDIPP=$(usex cxx)
		-DDOCUMENTATION=$(usex doc)
		-DEXAMPLES=$(usex examples)
		-DPYTHON_BINDINGS=$(usex python)
		-DBUILD_TESTS=$(usex test)
		-DFTDI_EEPROM=$(usex tools)
		-DCMAKE_SKIP_BUILD_RPATH=ON
		-DSTATICLIBS=OFF
	)
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}/test" || die
	LD_LIBRARY_PATH="${BUILD_DIR}/src" ./test_libftdi1 -l all || die
}

src_install() {
	cmake_src_install

	# Fix up pkgconfig files
	# bug #766818
	if use cxx ; then
		sed -i -e "s/libftdipp1/libftdi1/" "${ED}"/usr/$(get_libdir)/pkgconfig/libftdi1.pc || die
		sed -i -e "s/libftdi1/libftdipp1/" "${ED}"/usr/$(get_libdir)/pkgconfig/libftdipp1.pc || die
	fi

	use python && python_optimize
	dodoc AUTHORS ChangeLog README TODO

	if use doc ; then
		# Clean up crap man pages. #356369
		rm -vf "${BUILD_DIR}"/doc/man/man3/_* || die

		doman "${BUILD_DIR}"/doc/man/man3/*
		dodoc -r "${BUILD_DIR}"/doc/html
	fi

	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi
}
