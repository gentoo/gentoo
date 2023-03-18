# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Free, redistributable digital camera software application"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="aalib ncurses nls readline"

# aalib -> needs libjpeg
RDEPEND="
	>=dev-libs/popt-1.6.1
	>=media-libs/libexif-0.6.9
	>=media-libs/libgphoto2-2.5.17:=[exif]
	aalib? (
		media-libs/aalib
		media-libs/libjpeg-turbo
	)
	ncurses? ( dev-libs/cdk:= )
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.14.1 )
"

PATCHES=(
	"${FILESDIR}"/${P}-clang-16.patch
)

src_prepare() {
	default
	# Leave GCC debug builds under user control
	sed -r '/(C|LD)FLAGS/ s/ -g( |")/\1/' \
		-i configure{.ac,} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with aalib) \
		$(use_with aalib jpeg) \
		$(use_with ncurses cdk) \
		$(use_enable nls) \
		$(use_with readline)
}
