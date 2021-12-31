# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils user

DESCRIPTION="A grep for network layers"
HOMEPAGE="http://ngrep.sourceforge.net/"
SRC_URI="mirror://sourceforge/ngrep/${P}.tar.bz2"

LICENSE="ngrep"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
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
