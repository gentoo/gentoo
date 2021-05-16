# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop l10n

DESCRIPTION="Very fast real-time fractal zoomer"
HOMEPAGE="http://matek.hu/xaos/doku.php"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}.png.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE="aalib doc -gtk nls png svga threads X"

RDEPEND="
	sci-libs/gsl:=
	sys-libs/zlib
	aalib? ( media-libs/aalib )
	gtk? ( x11-libs/gtk+:2 )
	png? ( media-libs/libpng:0= )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="
	virtual/pkgconfig
	doc? ( virtual/texi2dvi )
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6-buildsystem.patch
	"${FILESDIR}"/${PN}-3.4-include.patch
	"${FILESDIR}"/${PN}-3.5-build-fix-i686.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf

	if use nls; then
		if [[ ${LINGUAS+set} == set ]]; then
			strip-linguas -i src/i18n
			sed -i -e '/^ALL_LINGUAS=/d' configure || die
			export ALL_LINGUAS="${LINGUAS}"
		fi
	else
		sed -i -e '/^ALL_LINGUAS=/d' configure || die
	fi
}

src_configure() {
	econf \
		--with-sffe=yes \
		--with-gsl=yes \
		$(use_enable nls) \
		$(use_with png) \
		$(use_with aalib aa-driver) \
		$(use_with gtk gtk-driver) \
		$(use_with threads pthread) \
		$(use_with X x11-driver) \
		$(use_with X x)
}

src_compile() {
	default

	if use doc; then
		emake -C doc xaos.dvi
		dvipdf doc/xaos.dvi || die

		emake -C help html
		rm -r help/rest || die
		HTML_DOCS=( help/. )
	fi
}

src_install() {
	default
	use doc && dodoc xaos.pdf

	make_desktop_entry "xaos -driver $(usex gtk '"GTK+ Driver"' x11)" "XaoS Fractal Zoomer" \
		xaos "Education;Math;Graphics;"
	doicon "${WORKDIR}"/${PN}.png
}
