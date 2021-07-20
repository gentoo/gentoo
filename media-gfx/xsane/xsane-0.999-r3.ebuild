# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop epatch strip-linguas toolchain-funcs

DESCRIPTION="Graphical scanning frontend"
HOMEPAGE="http://www.xsane.org/"
SRC_URI="
	http://www.xsane.org/download/${P}.tar.gz
	https://dev.gentoo.org/~dilfridge/distfiles/${PN}-0.998-patches-2.tar.xz
	https://dev.gentoo.org/~pacho/${PN}/${PN}-256x256.png
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls jpeg png tiff gimp lcms ocr"

RDEPEND="
	media-gfx/sane-backends
	x11-libs/gtk+:2
	x11-misc/xdg-utils
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	gimp? ( media-gfx/gimp:0/2 )
	lcms? ( media-libs/lcms:2 )
"
PDEPEND="ocr? ( app-text/gocr )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default

	strip-linguas -i po/ #609672

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
	eapply "${FILESDIR}/${PN}-0.999-lcms2.patch"

	mv configure.in configure.ac || die
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
		local gimptool=( "${EPREFIX}"/usr/bin/gimptool* )
		if [[ ${#gimptool[@]} -gt 0 ]]; then
			plugindir="$("${gimptool[0]}" --gimpplugindir)/plug-ins"
		else
			die "Can't find GIMP plugin directory."
		fi
		mkdir -p "${D}${plugindir}" || die
		ln -s ../../../../bin/xsane "${D}${plugindir}"/xsane || die
	fi

	newicon "${DISTDIR}/${PN}-256x256.png" "${PN}".png
}
