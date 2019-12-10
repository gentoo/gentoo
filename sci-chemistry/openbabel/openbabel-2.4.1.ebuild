# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"

inherit cmake-utils eutils wxwidgets

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/${P}.tar.gz"

# See src/CMakeLists.txt for LIBRARY_VERSION
SLOT="0/5.0.0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc openmp test wxwidgets"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/libxml2:2
	sci-libs/inchi
	sys-libs/zlib
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS NEWS.md README.md THANKS doc/dioxin.{inc,mol2} doc/README.{dioxin.pov,povray} )

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.2-gcc-6_and_7-backport.patch
	"${FILESDIR}"/${P}-gcc-8.patch
	)

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
		FORTRAN_NEED_OPENMP=1
	fi
}

src_prepare() {
	sed \
		-e '/__GNUC__/s:== 4:>= 4:g' \
		-i include/openbabel/shared_ptr.h || die
	cmake-utils_src_prepare
}

src_configure() {
	use wxwidgets && need-wxwidgets unicode
	local mycmakeargs=(
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		-DOPENMP=$(usex openmp)
		-DBUILD_GUI=$(usex wxwidgets)
	)

	cmake-utils_src_configure
}

src_install() {
	docinto html
	dodoc doc/{*.html,*.png}
	if use doc ; then
		docinto html/API
		dodoc -r doc/API/html/*
	fi

	cmake-utils_src_install
}

src_test() {
	local mycmakeargs=(
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		-DPYTHON_EXECUTABLE=false
		-DOPENMP=$(usex openmp)
		-DBUILD_GUI=$(usex wxwidgets)
		-DTESTS=$(usex test)
	)

	cmake-utils_src_configure
	cmake-utils_src_compile
	cmake-utils_src_test -E py
}

pkg_postinst() {
	optfeature "perl support" sci-chemistry/openbabel-perl
	optfeature "python support" sci-chemistry/openbabel-python
}
