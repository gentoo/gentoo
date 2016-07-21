# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils autotools

DESCRIPTION="pslib is a C-library to create PostScript files on the fly"
HOMEPAGE="http://pslib.sourceforge.net/"
SRC_URI="mirror://sourceforge/pslib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug jpeg png static-libs tiff"

RDEPEND="
	png? ( >=media-libs/libpng-1.2.43-r2:0 )
	jpeg? ( virtual/jpeg )
	tiff? ( media-libs/tiff )"
#gif? requires libungif, not in portage
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-libs/glib-2
	dev-util/intltool
	dev-perl/XML-Parser"

src_prepare() {
	# hackpatchfix underlinking
	sed -i -e 's/$(TIFF_LIBS)/$(TIFF_LIBS) -lm/' src/Makefile.am || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-bmp \
		$(use_enable static-libs static) \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_with tiff) \
		$(use_with debug)
}

src_install() {
	default

	prune_libtool_files --all
}
