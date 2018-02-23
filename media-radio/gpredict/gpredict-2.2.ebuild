# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Real-time satellite tracking and orbit prediction application"
HOMEPAGE="http://gpredict.oz9aec.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/gdk-pixbuf[jpeg]
	x11-libs/gtk+:3
	x11-libs/goocanvas:2.0
	net-misc/curl"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	eapply_user
	# remove wrong doc location
	eapply -p0 "${FILESDIR}/${PN}-2.0-doc.patch"
}
