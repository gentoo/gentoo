# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Command line tool for ripping DVDs and encoding to AVI/OGM/MKV/MP4"
HOMEPAGE="http://ogmrip.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogmrip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.14:2
	>=media-video/ogmrip-0.13.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool
		sys-devel/gettext )"

src_prepare() {
	default
	sed -i \
		-e '/CFLAGS/s:-Werror::' \
		configure || die
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO

	insinto /etc
	doins shrip.conf
}
