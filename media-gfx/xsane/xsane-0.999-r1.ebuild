# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xsane/xsane-0.999-r1.ebuild,v 1.7 2014/12/04 08:36:58 ago Exp $

EAPI=5
inherit autotools eutils toolchain-funcs

DESCRIPTION="graphical scanning frontend"
HOMEPAGE="http://www.xsane.org/"
SRC_URI="
	http://www.xsane.org/download/${P}.tar.gz
	http://dev.gentoo.org/~dilfridge/distfiles/${PN}-0.998-patches-2.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="nls jpeg png tiff gimp lcms ocr"

RDEPEND="
	media-gfx/sane-backends
	x11-libs/gtk+:2
	x11-misc/xdg-utils
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	gimp? ( media-gfx/gimp )
	lcms? ( media-libs/lcms:2 )
"

PDEPEND="ocr? ( app-text/gocr )"

DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
"

src_prepare() {
	# Apply multiple fixes from different distributions
	# Drop included patch and reuse patchset from prior version
	rm "${WORKDIR}/${PN}-0.998-patches-2"/005-update-param-crash.patch || die
	epatch "${WORKDIR}/${PN}-0.998-patches-2"/*.patch

	# Fix compability with libpng15 wrt #377363
	sed -i -e 's:png_ptr->jmpbuf:png_jmpbuf(png_ptr):' src/xsane-save.c || die

	# Fix AR calling directly (bug #442606)
	sed -i -e 's:ar r:$(AR) r:' lib/Makefile.in || die
	tc-export AR

	# Add support for lcms-2 (from Fedora)
	epatch "${FILESDIR}/${PN}-0.999-lcms2.patch"
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		--enable-gtk2 \
		$(use_enable nls) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable tiff) \
		$(use_enable gimp) \
		$(use_enable lcms)
}

src_install() {
	default

	dodoc xsane.*

	# link xsane so it is seen as a plugin in gimp
	if use gimp; then
		local plugindir
		if [ -x "${EPREFIX}"/usr/bin/gimptool ]; then
			plugindir="$(gimptool --gimpplugindir)/plug-ins"
		elif [ -x "${EPREFIX}"/usr/bin/gimptool-2.0 ]; then
			plugindir="$(gimptool-2.0 --gimpplugindir)/plug-ins"
		else
			die "Can't find GIMP plugin directory."
		fi
		dodir "${plugindir#${EPREFIX}}"
		dosym /usr/bin/xsane "${plugindir#${EPREFIX}}"/xsane
	fi

	newicon src/xsane-48x48.png ${PN}.png
}
