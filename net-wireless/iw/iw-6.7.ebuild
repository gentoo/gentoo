# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="nl80211 configuration utility for wireless devices using the mac80211 stack"
HOMEPAGE="https://wireless.wiki.kernel.org/en/users/Documentation/iw"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/network/${PN}/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-libs/libnl:="
RDEPEND="
	${DEPEND}
	net-wireless/wireless-regdb
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	tc-export CC LD PKG_CONFIG

	# do not compress man pages by default.
	sed 's@\(iw\.8\)\.gz@\1@' -i Makefile || die
}

src_compile() {
	# Set flags prior so they are honored
	CFLAGS="${CFLAGS:+${CFLAGS} }${CPPFLAGS}"
	LDFLAGS="${CFLAGS:+${CFLAGS} }${LDFLAGS}"
	emake V=1
}

src_install() {
	emake V=1 DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
