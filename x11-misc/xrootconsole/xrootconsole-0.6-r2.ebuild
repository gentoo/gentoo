# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utility that displays its input in a text box on your root window"
HOMEPAGE="https://sourceforge.net/projects/xrootconsole/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}.noversion.patch"
	"${FILESDIR}/${P}.makefile.patch"
	"${FILESDIR}/${P}.manpage.patch"
)

src_compile() {
	tc-export CC PKG_CONFIG
	emake
}

src_install() {
	dodir /usr/bin

	emake \
		MANDIR="${ED}/usr/share/man/man1" \
		BINDIR="${ED}/usr/bin/" \
		install

	einstalldocs
}
