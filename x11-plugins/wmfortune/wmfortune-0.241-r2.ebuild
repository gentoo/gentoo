# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="a dockapp showing fortune-mod messages"
HOMEPAGE="https://www.dockapps.net/wmfortune"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="games-misc/fortune-mod
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-stringh.patch )

src_prepare() {
	# Honour Gentoo LDFLAGS. Closes bug #336446.
	sed -i 's/-o $(DEST)/$(LDFLAGS) -o $(DEST)/' Makefile || die
	default
}

src_compile() {
	emake CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}" \
		XLIBDIR="/usr/$(get_libdir)"
}

src_install() {
	dobin ${PN}
	einstalldocs
}
