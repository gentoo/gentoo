# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="A utility to connect the mouse and keyboard to another X"
HOMEPAGE="https://github.com/dottedmag/x2x"
SRC_URI="https://github.com/dottedmag/x2x/archive/refs/tags/debian/${PV}-10.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-debian-1.30-10

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Patch to fix bug #126939
	# AltGr does not work in x2x with different keymaps:
	"${FILESDIR}"/${PN}_1.30-10-keymap.patch
)

DOCS=( README AUTHORS INSTALL ChangeLog ChangeLog.old )

src_prepare() {
	default

	eautoreconf

	append-cflags -std=gnu89 # old codebase, incompatible with c2x
}

src_compile() {
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	default
	dodoc -r docs/
}
