# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Icecast OGG streaming client, supports on the fly re-encoding"
HOMEPAGE="https://icecast.org/ices/"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc64 sparc x86"

RDEPEND="
	acct-group/ices
	acct-user/ices
	dev-libs/libxml2
	>=media-libs/libshout-2
	>=media-libs/libvorbis-1
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf --sysconfdir=/etc/ices2
}

src_install() {
	default
	insinto /etc/ices2
	doins conf/*.xml
	docinto html
	dodoc doc/*.{html,css}
	newinitd "${FILESDIR}"/ices.initd-r1 ices
	keepdir /var/log/ices
	fperms 660 /var/log/ices
	fowners ices:ices /var/log/ices
	rm -rf "${D}"/usr/share/ices
}
