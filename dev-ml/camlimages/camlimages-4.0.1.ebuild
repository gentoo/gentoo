# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/camlimages/camlimages-4.0.1.ebuild,v 1.5 2013/05/24 15:46:20 aballier Exp $

EAPI=5

inherit eutils vcs-snapshot findlib multilib

DESCRIPTION="An image manipulation library for ocaml"
HOMEPAGE="http://gallium.inria.fr/camlimages/"
SRC_URI="http://bitbucket.org/camlspotter/camlimages/get/v4.0.1.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ppc x86"
IUSE="doc gif gtk jpeg png postscript tiff truetype X xpm zlib"

RDEPEND=">=dev-lang/ocaml-3.10.2:=[X?,ocamlopt]
	gif? ( media-libs/giflib )
	gtk? ( dev-ml/lablgtk )
	jpeg? ( virtual/jpeg )
	tiff? ( media-libs/tiff )
	png? ( >=media-libs/libpng-1.4:0 )
	postscript? ( app-text/ghostscript-gpl )
	truetype? ( >=media-libs/freetype-2 )
	xpm? ( x11-libs/libXpm )
	X? ( x11-apps/rgb )
	zlib? ( sys-libs/zlib )
	"
DEPEND="${DEPEND}
	doc? ( dev-python/sphinx[latex] )
	dev-util/omake
	dev-ml/findlib"

REQUIRED_USE="png? ( zlib )"

src_prepare() {
	epatch "${FILESDIR}/${P}-libpng15.patch"
}

camlimages_disable_have() {
	if ! use $1 ; then
		sed -i -e "s/^[[:space:]]*HAVE_$2.*\$/  HAVE_$2 = false/" OMakefile || die
		sed -i -e "s/^[[:space:]]*SUPPORT_$2.*\$/\0\n  SUPPORT_$2 = false/" OMakefile || die
	fi
}

src_configure() {
	camlimages_disable_have gif         GIF
	camlimages_disable_have zlib        Z
	camlimages_disable_have png         PNG
	camlimages_disable_have jpeg        JPEG
	camlimages_disable_have tiff        TIFF
	camlimages_disable_have xpm         XPM
	camlimages_disable_have postscript  PS
	camlimages_disable_have gtk         LABLGTK2
	camlimages_disable_have X           GRAPHICS
	camlimages_disable_have X           RGB_TXT
	camlimages_disable_have truetype    FREETYPE
}

src_compile() {
	omake --force-dotomake || die
	if use doc ; then
		sphinx-build doc/sphinx sphinxdoc || die
	fi
}

src_install() {
	findlib_src_preinst
	omake --force-dotomake DESTDIR="${D}" install || die
	dodoc README
	use doc && dohtml -r sphinxdoc/*
}
