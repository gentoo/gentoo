# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit cmake-utils eutils wxwidgets

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc openmp test wxwidgets"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/libxml2:2
	sci-libs/inchi
	sys-libs/zlib
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	doc? ( app-doc/doxygen )"

DOCS="AUTHORS ChangeLog NEWS README THANKS doc/*.inc doc/README* doc/*.mol2"

PATCHES=( "${FILESDIR}"/${P}-test_lib_path.patch )

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
	need-wxwidgets unicode
	local mycmakeargs=()
	mycmakeargs+=(
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		$(cmake-utils_use_enable openmp OPENMP)
		$(cmake-utils_use wxwidgets BUILD_GUI)
	)

	cmake-utils_src_configure
}

src_install() {
	dohtml doc/{*.html,*.png}
	if use doc ; then
		insinto /usr/share/doc/${PF}/API/html
		doins doc/API/html/*
	fi

	cmake-utils_src_install
}

src_test() {
	local mycmakeargs=""
	mycmakeargs="${mycmakeargs}
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		-DPYTHON_EXECUTABLE=false
		$(cmake-utils_use_enable openmp OPENMP)
		$(cmake-utils_use wxwidgets BUILD_GUI)
		$(cmake-utils_use_enable test TESTS)"

	cmake-utils_src_configure
	cmake-utils_src_compile
	cmake-utils_src_test -E py
}

pkg_postinst() {
	optfeature "perl support" sci-chemistry/openbabel-perl
	optfeature "python support" sci-chemistry/openbabel-python
}
