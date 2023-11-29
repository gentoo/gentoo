# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gnome2-utils

DESCRIPTION="A library for reading vector images in Microsoft's Windows Metafile Format (WMF)"
HOMEPAGE="https://github.com/caolanm/libwmf http://wvware.sourceforge.net/"
SRC_URI="https://github.com/caolanm/libwmf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug doc expat X"

RDEPEND="
	app-text/ghostscript-gpl
	media-fonts/urw-fonts
	media-libs/freetype:2=
	media-libs/libpng:=
	media-libs/libjpeg-turbo
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2= )
	X? (
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXpm
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS BUILDING ChangeLog CREDITS INSTALL NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.8.4-build.patch
	"${FILESDIR}"/${PN}-0.2.8.4-libpng-1.5.patch
	"${FILESDIR}"/${PN}-0.2.8.4-pngfix.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Support for GD is disabled, since it's never linked, even, when enabled
	# See https://bugs.gentoo.org/268161
	local myeconfargs=(
		--disable-gd
		--disable-static
		$(use_enable debug)
		$(use_with expat)
		$(use_with !expat libxml2)
		$(use_with X x)
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		--with-fontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-freetype
		--with-gsfontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-gsfontmap="${EPREFIX}"/usr/share/ghostscript/9.21/Resource/Init/Fontmap
		--with-jpeg
		--with-layers
		--with-png
		--with-sys-gd
		--with-zlib
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	# address parallel build issue, bug 677566
	MAKEOPTS=-j1

	default
	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	gnome2_gdk_pixbuf_update
}
