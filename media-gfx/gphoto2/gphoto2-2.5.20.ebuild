# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Free, redistributable digital camera software application"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ppc ppc64 ~sparc x86"
IUSE="aalib exif ncurses nls readline"

# aalib -> needs libjpeg
RDEPEND="
	dev-libs/popt
	>=media-libs/libgphoto2-2.5.17:=[exif?]
	aalib? (
		media-libs/aalib
		virtual/jpeg:0 )
	exif? (	media-libs/libexif )
	ncurses? ( dev-libs/cdk:0= )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.14.1 )
"

PATCHES=(
	# https://github.com/gphoto/gphoto2/pull/179
	"${FILESDIR}"/0001-Fix-unwanted-automagic-activation-of-aalib-support.patch
)

src_prepare() {
	default
	if ! use exif ; then
		# Remove tests that require EXIF to pass, bug 610024
		rm "${S}"/tests/data/test0{35,36,37,40}* || die
	fi
	# Leave GCC debug builds under user control
	sed -r '/(C|LD)FLAGS/ s/ -g( |")/\1/' \
		-i configure{.ac,} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with aalib) \
		$(use_with aalib jpeg) \
		$(use_with exif libexif auto) \
		$(use_with ncurses cdk) \
		$(use_enable nls) \
		$(use_with readline)
}
