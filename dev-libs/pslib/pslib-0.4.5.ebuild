# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="pslib is a C-library to create PostScript files on the fly"
HOMEPAGE="http://pslib.sourceforge.net/"
SRC_URI="mirror://sourceforge/pslib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug jpeg png static-libs tiff"

RDEPEND="
	png? ( media-libs/libpng:0= )
	jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0= )"
#gif? requires libungif, not in portage
DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-libs/glib-2
	dev-util/intltool
	dev-perl/XML-Parser"

PATCHES=( "${FILESDIR}"/${PN}-0.4.5-fix-build-system.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
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

	# package installs .pc files
	find "${D}" -name '*.la' -delete || die
}
