# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils multilib

DESCRIPTION="Use most socks-friendly applications with Tor"
HOMEPAGE="https://code.google.com/p/torsocks"
SRC_URI="https://${PN}.googlecode.com/files/${PN}-1.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

# We do not depend on tor which might be running on a different box
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/suppress-warning-msgs.patch
	epatch "${FILESDIR}"/fix-docdir.patch
	eautoreconf
}

src_configure() {
	econf --docdir=/usr/share/doc/${PF} \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README TODO INSTALL ChangeLog

	#Remove libtool .la files
	cd "${D}"/usr/$(get_libdir)/torsocks
	rm -f *.la
}
