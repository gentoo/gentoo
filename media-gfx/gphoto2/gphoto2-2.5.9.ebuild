# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit autotools

DESCRIPTION="Free, redistributable digital camera software application"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="aalib exif ncurses nls readline"

# aalib -> needs libjpeg
RDEPEND="
	dev-libs/popt
	>=media-libs/libgphoto2-2.5.6[exif?]
	aalib? (
		media-libs/aalib
		virtual/jpeg:0 )
	exif? (	media-libs/libexif )
	ncurses? ( dev-libs/cdk )
	readline? ( sys-libs/readline:0 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.14.1 )
"

src_prepare() {
	# Leave GCC debug builds under user control
	sed -r '/(C|LD)FLAGS/ s/ -g( |")/\1/' \
		-i configure{.ac,} || die
	eautoreconf
}

src_configure() {
	CPPFLAGS="-I/usr/include/cdk" \
		econf \
			--docdir=/usr/share/doc/${PF} \
			$(use_with aalib) \
			$(use_with aalib jpeg) \
			$(use_with exif libexif auto) \
			$(use_with ncurses cdk) \
			$(use_enable nls) \
			$(use_with readline)
}

src_install() {
	emake DESTDIR="${D}" \
		HTML_DIR="${D}"/usr/share/doc/${PF}/sgml \
		install

	dodoc ChangeLog NEWS* README AUTHORS
	rm -rf "${D}"/usr/share/doc/${PF}/sgml/gphoto2
}
