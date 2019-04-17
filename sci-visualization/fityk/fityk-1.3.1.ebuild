# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER=3.0

PYTHON_COMPAT=( python2_7 python{3_5,3_6} )

inherit fdo-mime python-r1 wxwidgets

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="http://fityk.nieto.pl/"
SRC_URI="https://github.com/wojdyr/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="gnuplot nlopt python readline static-libs wxwidgets"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="
	>=dev-lang/lua-5.1:0
	dev-libs/boost:=
	>=sci-libs/xylib-1
	nlopt? ( sci-libs/nlopt )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )"
DEPEND="${CDEPEND}
	dev-lang/swig"
RDEPEND="${CDEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

pkg_setup() {
	use wxwidgets && setup-wxwidgets
}

src_prepare() {
	default
	use python && python_copy_sources
}

src_configure() {
	common_confargs=(
		--with-wx-config=wx-config-${WX_GTK_VER}
	)

	econf \
		"${common_confargs[@]}" \
		--disable-python \
		$(use_enable nlopt) \
		$(use_enable wxwidgets GUI) \
		$(use_with readline) \
		$(use_enable static-libs static)

	if use python; then
		python_configure() {
			econf \
				"${common_confargs[@]}" \
				--enable-python \
				--disable-nlopt \
				--disable-GUI \
				--without-readline
		}
		python_foreach_impl run_in_build_dir python_configure
	fi
}

src_compile() {
	default

	if use python; then
		python_compilation() {
			emake -C fityk swig/_fityk.la
		}
		python_foreach_impl run_in_build_dir python_compilation
	fi
}

src_install() {
	default

	if use python; then
		python_installation() {
			emake DESTDIR="${D}" -C fityk install-pyexecLTLIBRARIES
			rm "${D%/}"/$(python_get_sitedir)/*.la || die
		}
		python_foreach_impl run_in_build_dir python_installation
	fi

	# No .pc file / libfityk.a has dependencies -> need .la file
	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
