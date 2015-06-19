# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ezstream/ezstream-0.5.6.ebuild,v 1.2 2012/05/05 08:20:42 mgorny Exp $

EAPI=4

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

	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die

	rm -f "${D}"/usr/share/doc/${PF}/COPYING
}
