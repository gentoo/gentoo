# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="pslib is a C-library to create PostScript files on the fly"
HOMEPAGE="https://pslib.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/pslib/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~sparc ~x86"
IUSE="debug jpeg png tiff"

RDEPEND="
	png? ( media-libs/libpng:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	tiff? ( media-libs/tiff:= )"
#gif? requires libungif, not in portage
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	dev-libs/glib:2
	dev-util/intltool
	dev-perl/XML-Parser
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.5-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.4.6-Fix-implicit-function-declarations.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-bmp \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_with tiff) \
		$(use_with debug)
}

src_install() {
	default

	# package installs .pc files
	find "${ED}" -name '*.la' -delete || die
}
