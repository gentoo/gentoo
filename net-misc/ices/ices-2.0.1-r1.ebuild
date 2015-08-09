# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils user

DESCRIPTION="Icecast OGG streaming client, supports on the fly re-encoding"
HOMEPAGE="http://www.icecast.org/ices.php"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc64 sparc x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	>=media-libs/libshout-2
	>=media-libs/libvorbis-1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	enewgroup ices
	enewuser ices -1 -1 -1 ices
}

src_compile() {
	econf --sysconfdir=/etc/ices2
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS README TODO
	insinto /etc/ices2
	doins conf/*.xml
	dohtml doc/*.{html,css}
	newman debian/ices2.1 ices.1
	newinitd "${FILESDIR}"/ices.initd ices
	keepdir /var/log/ices
	fperms 660 /var/log/ices
	fowners ices:ices /var/log/ices
	rm -rf "${D}"/usr/share/ices
}
