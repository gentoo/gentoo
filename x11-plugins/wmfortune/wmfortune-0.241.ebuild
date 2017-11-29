# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils multilib toolchain-funcs

DESCRIPTION="a dockapp showing fortune-mod messages"
HOMEPAGE="http://www.dockapps.net/wmfortune"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-misc/fortune-mod
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-stringh.patch

	# Honour Gentoo LDFLAGS. Closes bug #336446.
	sed -i 's/-o $(DEST)/$(LDFLAGS) -o $(DEST)/' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}" \
		XLIBDIR="/usr/$(get_libdir)" || die "emake failed."
}

src_install() {
	dobin ${PN}
	dodoc CHANGES README TODO
}
