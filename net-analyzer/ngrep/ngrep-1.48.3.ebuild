# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A grep for network layers"
HOMEPAGE="https://github.com/jpr5/ngrep"
SRC_URI="https://github.com/jpr5/ngrep/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ngrep"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ipv6"

DEPEND="
	dev-libs/libpcre2
	net-libs/libpcap
	net-libs/libnet
"
RDEPEND="
	${DEPEND}
	acct-group/ngrep
	acct-user/ngrep
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable ipv6)
		--disable-pcap-restart
		--enable-pcre2
		--with-dropprivs-user=ngrep
		--with-pcap-includes="${EPREFIX}"/usr/include
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake STRIPFLAG="${CFLAGS}"
}
