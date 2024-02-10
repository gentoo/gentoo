# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="A minimalist, no frills window manager for X"
HOMEPAGE="https://www.6809.org.uk/evilwm/"
SRC_URI="https://www.6809.org.uk/evilwm/${P}.tar.gz"

LICENSE="MIT 9wm"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	sed -e 's/^#define DEF_FONT.*/#define DEF_FONT "fixed"/' \
		-i evilwm.h || die "sed font failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" INSTALL_STRIP="" install

	einstalldocs

	echo -e "#!${EPREFIX}/bin/sh\nexec \"${EPREFIX}/usr/bin/${PN}\"" > "${T}/${PN}" || die
	exeinto /etc/X11/Sessions
	doexe "${T}/${PN}"

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"
	domenu "${FILESDIR}"/evilwm.desktop
}
