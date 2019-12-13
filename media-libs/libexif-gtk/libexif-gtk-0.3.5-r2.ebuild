# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="GTK+ frontend to the libexif library (parsing, editing, and saving EXIF data)"
HOMEPAGE="http://libexif.sf.net"
SRC_URI="mirror://sourceforge/libexif/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	media-libs/libexif:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-confcheck.patch
	"${FILESDIR}"/${P}-gtk212.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable nls)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
