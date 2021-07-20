# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A grep for network layers"
HOMEPAGE="https://github.com/jpr5/ngrep"
SRC_URI="https://github.com/jpr5/ngrep/archive/V${PV/./_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/./_}"

LICENSE="ngrep"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ipv6"

DEPEND="
	dev-libs/libpcre
	net-libs/libpcap
"

RDEPEND="
	${DEPEND}
	acct-group/ngrep
	acct-user/ngrep
"

PATCHES=( "${FILESDIR}"/${PN}-1.47-regex.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable ipv6)
		--disable-pcap-restart
		--enable-pcre
		--with-dropprivs-user=ngrep
		--with-pcap-includes="${EPREFIX}"/usr/include/pcap
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C regex-0.12
	emake STRIPFLAG="${CFLAGS}"
}
