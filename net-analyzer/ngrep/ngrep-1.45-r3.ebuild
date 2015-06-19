# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ngrep/ngrep-1.45-r3.ebuild,v 1.10 2014/07/14 23:41:43 jer Exp $

EAPI=5

inherit autotools eutils user

DESCRIPTION="A grep for network layers"
HOMEPAGE="http://ngrep.sourceforge.net/"
SRC_URI="mirror://sourceforge/ngrep/${P}.tar.bz2"

LICENSE="ngrep"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ipv6"

DEPEND="
	dev-libs/libpcre
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

DOCS=(
	doc/CHANGES.txt
	doc/CREDITS.txt
	doc/README.txt
	doc/REGEX.txt
)

src_prepare() {
	# Remove bundled libpcre to avoid occasional linking with them
	rm -r pcre-5.0 || die

	epatch \
		"${FILESDIR}"/${P}-build-fixes.patch \
		"${FILESDIR}"/${P}-setlocale.patch \
		"${FILESDIR}"/${P}-prefix.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		--disable-pcap-restart \
		--enable-pcre \
		--with-dropprivs-user=ngrep \
		--with-pcap-includes="${EPREFIX}"/usr/include/pcap
}

pkg_preinst() {
	enewgroup ngrep
	enewuser ngrep -1 -1 -1 ngrep
}
