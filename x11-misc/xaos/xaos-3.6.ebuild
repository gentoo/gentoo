# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils eutils

DESCRIPTION="Very fast real-time fractal zoomer"
HOMEPAGE="http://matek.hu/xaos/doku.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}.png.tar"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="aalib doc -gtk nls png svga threads X"

RDEPEND="
	sci-libs/gsl:0=
	sys-libs/zlib:0=
	aalib? ( media-libs/aalib:0= )
	gtk? ( x11-libs/gtk+:2= )
	nls? ( sys-devel/gettext )
	png? ( media-libs/libpng:0= )
	X? ( x11-libs/libX11:0=
		 x11-libs/libXext:0=
		 x11-libs/libXxf86vm:0= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/texi2dvi )
	X? (
		x11-proto/xf86vidmodeproto
		x11-proto/xextproto
		x11-proto/xproto )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4-png.patch
	"${FILESDIR}"/${PN}-3.4-include.patch
	"${FILESDIR}"/${PN}-3.5-build-fix-i686.patch
	"${FILESDIR}"/${PN}-3.6-locale-dir.patch
	"${FILESDIR}"/${PN}-3.6-no-auto-strip.patch
)

src_prepare() {
	autotools-utils_src_prepare
	if use nls; then
		if [[ "${LINGUAS+set}" == "set" ]]; then
			strip-linguas -i src/i18n
			sed -i -e '/^ALL_LINGUAS=/d' configure || die
			export ALL_LINGUAS="${LINGUAS}"
		fi
	else
		sed -i -e '/^ALL_LINGUAS=/d' configure || die
	fi
}

src_configure() {
	local myeconfargs=(
		--with-sffe=yes
		--with-gsl=yes
		$(use_enable nls)
		$(use_with png)
		$(use_with aalib aa-driver)
		$(use_with gtk gtk-driver)
		$(use_with threads pthread)
		$(use_with X x11-driver)
		$(use_with X x)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		cd "${BUILD_DIR}"/doc
		emake xaos.dvi
		dvipdf xaos.dvi || die
		cd "${BUILD_DIR}"/help
		emake html
	fi
}

src_install() {
	autotools-utils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/xaos.pdf
		dohtml -r help/*
	fi
	local driver="x11"
	use gtk && driver="\"GTK+ Driver\""
	make_desktop_entry "xaos -driver ${driver}" "XaoS Fractal Zoomer" \
		xaos "Application;Education;Math;Graphics;"
	doicon "${WORKDIR}"/${PN}.png
}
