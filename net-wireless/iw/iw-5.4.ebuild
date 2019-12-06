# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="nl80211-based configuration utility for wireless devices using the mac80211 kernel stack"
HOMEPAGE="https://wireless.kernel.org/en/users/Documentation/iw"
SRC_URI="https://www.kernel.org/pub/software/network/${PN}/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/libnl:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	tc-export CC LD PKG_CONFIG

	# do not compress man pages by default.
	sed 's@\(iw\.8\)\.gz@\1@' -i Makefile || die
}

src_compile() {
	CFLAGS="${CFLAGS} ${CPPFLAGS}" \
	LDFLAGS="${CFLAGS} ${LDFLAGS}" \
	emake V=1
}

src_install() {
	emake V=1 DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
