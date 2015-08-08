# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="M(easuring)buffer is a replacement for buffer with additional functionality"
HOMEPAGE="http://www.maier-komor.de/mbuffer.html"
SRC_URI="http://www.maier-komor.de/software/mbuffer/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_prepare() {
	ln -s "${DISTDIR}"/${P}.tgz test.tar #258881
	# work around "multi off" in /etc/host.conf and "::1 localhost"
	# *not* being the *first* "localhost" entry in /etc/hosts
	epatch "${FILESDIR}/${PN}-20121111-resolv-multi-order-issue.patch"
}

src_configure() {
	econf \
		$(use_enable ssl md5) \
		$(use_enable debug)
}
