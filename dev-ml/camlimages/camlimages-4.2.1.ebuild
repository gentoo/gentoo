# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils vcs-snapshot findlib multilib

DESCRIPTION="An image manipulation library for ocaml"
HOMEPAGE="http://gallium.inria.fr/camlimages/"
SRC_URI="https://bitbucket.org/camlspotter/camlimages/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc exif gif gtk jpeg png postscript tiff truetype X xpm"

RDEPEND=">=dev-lang/ocaml-3.10.2:=[X?,ocamlopt]
	exif? ( media-libs/libexif )
	gif? ( media-libs/giflib )
	gtk? ( dev-ml/lablgtk )
	jpeg? ( virtual/jpeg )
	tiff? ( media-libs/tiff )
	png? ( >=media-libs/libpng-1.4:0 )
	postscript? ( app-text/ghostscript-gpl )
	truetype? ( >=media-libs/freetype-2 )
	xpm? ( x11-libs/libXpm )
	X? ( x11-apps/rgb )
	sys-libs/zlib
	"
DEPEND="${DEPEND}
	doc? ( dev-python/sphinx[latex] )
	dev-util/omake
	virtual/pkgconfig
	dev-ml/findlib"

camlimages_arg_want() {
	echo "ARG_WANT_${2}=$(usex $1 1 0)"
}

src_compile() {
	omake \
		$(camlimages_arg_want exif        EXIF    ) \
		$(camlimages_arg_want gif         GIF     ) \
		$(camlimages_arg_want png         PNG     ) \
		$(camlimages_arg_want jpeg        JPEG    ) \
		$(camlimages_arg_want tiff        TIFF    ) \
		$(camlimages_arg_want xpm         XPM     ) \
		$(camlimages_arg_want postscript  GS      ) \
		$(camlimages_arg_want gtk         LABLGTK2) \
		$(camlimages_arg_want X           GRAPHICS) \
		$(camlimages_arg_want truetype    FREETYPE) \
		PATH_GS=/bin/true \
		--force-dotomake || die

	if use doc ; then
		sphinx-build doc/sphinx sphinxdoc || die
	fi
}

src_install() {
	findlib_src_preinst
	omake --force-dotomake DESTDIR="${D}" install || die
	dodoc README.rst
	use doc && dohtml -r sphinxdoc/*
}
