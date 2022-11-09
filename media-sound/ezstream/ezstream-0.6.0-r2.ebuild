# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A command line source client for Icecast media streaming servers"
HOMEPAGE="https://www.icecast.org/ezstream/"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="taglib"

DEPEND="
	dev-libs/libxml2
	>=media-libs/libshout-2.2
	!taglib? ( media-libs/libvorbis )
	taglib? ( media-libs/taglib )"
RDEPEND="
	${DEPEND}
	net-misc/icecast"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--enable-examplesdir='$(docdir)/examples' \
		$(use_with taglib taglib "${ESYSROOT}"/usr)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	rm -f "${ED}"/usr/share/doc/${PF}/COPYING || die
}
