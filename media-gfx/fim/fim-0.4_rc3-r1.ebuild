# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Fbi-IMproved is a framebuffer image viewer based on Fbi and inspired from Vim"
HOMEPAGE="https://savannah.nongnu.org/projects/fbi-improved"
SRC_URI="http://download.savannah.gnu.org/releases/fbi-improved/${P/_rc/-rc}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="aalib dia djvu exif fbcon gif graphicsmagick imagemagick jpeg pdf png postscript readline sdl static svg tiff xfig"

RDEPEND="media-fonts/terminus-font
	aalib? ( media-libs/aalib[slang] )
	dia? ( app-office/dia )
	djvu? ( app-text/djvu )
	exif? ( media-libs/libexif )
	gif? ( media-libs/giflib )
	graphicsmagick? ( media-gfx/graphicsmagick )
	imagemagick? ( || ( media-gfx/graphicsmagick[imagemagick] media-gfx/imagemagick ) )
	jpeg? ( virtual/jpeg:0 )
	pdf? ( >=app-text/poppler-0.31 )
	png? ( media-libs/libpng:0 )
	postscript? ( app-text/libspectre )
	readline? ( sys-libs/readline:0 )
	sdl? ( media-libs/libsdl )
	svg? ( media-gfx/inkscape )
	tiff? ( media-libs/tiff:0 )
	xfig? ( media-gfx/xfig )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S=${WORKDIR}/${P/_rc/-rc}

src_prepare() {
	epatch "${FILESDIR}/${P}-poppler031.patch"
}

src_configure() {
	econf \
		$(use_enable aalib aa) \
		$(use_enable dia) \
		$(use_enable djvu) \
		$(use_enable exif) \
		$(use_enable fbcon framebuffer) \
		$(use_enable gif) \
		$(use_enable graphicsmagick) \
		$(use_enable imagemagick convert) \
		$(use_enable pdf poppler) \
		$(use_enable png) \
		$(use_enable postscript ps) \
		$(use_enable readline) \
		$(use_enable sdl) \
		$(use_enable static) \
		$(use_enable svg inkscape) \
		$(use_enable tiff) \
		$(use_enable xfig) \
		--disable-hardcoded-font \
		--disable-imlib2 \
		--disable-matrices-rendering \
		--disable-xcftopnm \
		--enable-fimrc \
		--enable-history \
		--enable-loader-string-specification \
		--enable-mark-and-dump \
		--enable-output-console \
		--enable-raw-bits-rendering \
		--enable-read-dirs \
		--enable-recursive-dirs \
		--enable-resize-optimizations \
		--enable-scan-consolefonts \
		--enable-screen \
		--enable-scripting \
		--enable-seek-magic \
		--enable-stdin-image-reading \
		--enable-unicode \
		--enable-warnings \
		--enable-windows \
		--with-default-consolefont=/usr/share/consolefonts/ter-114n.psf.gz
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install
}
