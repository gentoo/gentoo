# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="GTK+ frontend to the libexif library (parsing, editing, and saving EXIF data)"
HOMEPAGE="https://libexif.github.io/"
SRC_URI="mirror://sourceforge/libexif/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="nls static-libs"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	>=media-libs/libexif-0.6.12
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.5-confcheck.patch
	"${FILESDIR}"/${PN}-0.3.5-gtk212.patch
)
src_prepare() {
	default
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-gtk3
		$(use_enable static-libs static)
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
