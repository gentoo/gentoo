# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

PYTHON_COMPAT=( python2_7 python3_4 )

inherit autotools-utils fdo-mime python-r1 wxwidgets

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="http://fityk.nieto.pl/"
SRC_URI="https://github.com/wojdyr/${PN}/releases/download/v${PV}/${P}.tar.bz2"

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
	readline? ( sys-libs/readline:* )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )"
DEPEND="${CDEPEND}
	dev-libs/boost
	dev-lang/swig"
RDEPEND="${CDEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

src_prepare() {
	use python && python_copy_sources
	autotools-utils_src_prepare
}

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
	if use python; then
		python_compilation() {
			cd  "${BUILD_DIR}"/fityk || die
			einfo "in ${PWD}"
			emake swig/_fityk.la
		}
		python_foreach_impl python_compilation
	fi
}

src_install() {
	autotools-utils_src_install
	if use python; then
		python_installation() {
			cd  "${BUILD_DIR}"/fityk || die
			emake DESTDIR="${D}" install-pyexecLTLIBRARIES
			rm "${D}"/$(python_get_sitedir)/*.la || die
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
