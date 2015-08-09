# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.9"
GITHUB_USER="wojdyr"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit autotools-utils fdo-mime python-r1 wxwidgets

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="http://fityk.nieto.pl/"
SRC_URI="http://github.com/downloads/${GITHUB_USER}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="gnuplot nlopt readline python static-libs wxwidgets"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="
	>=sci-libs/xylib-1
	>=dev-lang/lua-5.1:0
	nlopt? ( sci-libs/nlopt )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	wxwidgets? ( >=x11-libs/wxGTK-2.9.2:2.9 )"
DEPEND="${CDEPEND}
	dev-libs/boost
	dev-lang/swig"
RDEPEND="${CDEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--disable-xyconvert
		--disable-python
		$(use_enable nlopt)
		$(use_enable wxwidgets GUI)
		$(use_with readline)
	)
	autotools-utils_src_configure
	if use python; then
		myeconfargs=(
		--disable-xyconvert
		--enable-python
		--disable-nlopt
		--disable-GUI
		--without-readline )
		python_foreach_impl autotools-utils_src_configure
	fi
}

src_compile() {
	autotools-utils_src_compile
	python_copy_sources
	if use python; then
		python_compilation() {
			pushd "${BUILD_DIR}"/fityk
			einfo "in ${PWD}"
			emake swig/_fityk.la
			popd
		}
		python_foreach_impl python_compilation
	fi
}

src_install() {
	autotools-utils_src_install
	if use python; then
		python_installation() {
			pushd "${BUILD_DIR}"/fityk
			emake DESTDIR="${D}" install-pyexecLTLIBRARIES
			popd
		}
		python_foreach_impl python_installation
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
