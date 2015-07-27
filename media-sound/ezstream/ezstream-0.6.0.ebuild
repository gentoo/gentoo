# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ezstream/ezstream-0.6.0.ebuild,v 1.1 2015/07/27 20:13:40 polynomial-c Exp $

EAPI=5

DESCRIPTION="A command line source client for Icecast media streaming servers"
HOMEPAGE="http://www.icecast.org/ezstream.php"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="taglib"

COMMON_DEPEND="dev-libs/libxml2
	>=media-libs/libshout-2.2
	media-libs/libvorbis
	taglib? ( media-libs/taglib )"
RDEPEND="${COMMON_DEPEND}
	net-misc/icecast"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_configure() {
	local docdir=/usr/share/doc/${PF}

	econf \
		--docdir=${docdir} \
		--enable-examplesdir=${docdir}/examples \
		$(use_with taglib)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	rm -f "${D}"/usr/share/doc/${PF}/COPYING
}
