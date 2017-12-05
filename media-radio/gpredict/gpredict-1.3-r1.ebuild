# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="Real-time satellite tracking and orbit prediction application"
HOMEPAGE="http://gpredict.oz9aec.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/gdk-pixbuf[jpeg]
	x11-libs/gtk+:2
	x11-libs/goocanvas:0
	net-misc/curl"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	# remove wrong doc location
	epatch "${FILESDIR}/${PN}-1.1-doc.patch"
	sed -i -e "s/0.15/0.14/g" configure.ac || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	make_desktop_entry ${PN} "GPredict" "/usr/share/pixmaps/gpredict/icons/gpredict-icon.png" Science
	# provide a link to GPL license to allow the program to show it (see
	# Help->license menu entry)
	dosym /usr/portage/licenses/GPL-2 /usr/share/${PN}/COPYING
	dodoc AUTHORS ChangeLog NEWS README TODO
}
