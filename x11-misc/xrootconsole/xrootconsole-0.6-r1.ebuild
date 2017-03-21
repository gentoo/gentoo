# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A utility that displays its input in a text box on your root window"
HOMEPAGE="https://sourceforge.net/projects/xrootconsole/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	x11-libs/libX11"

DEPEND="
	${RDEPEND}
	x11-proto/xproto"

PATCHES=(
	"${FILESDIR}/${P}.noversion.patch"
	"${FILESDIR}/${P}.makefile.patch"
	"${FILESDIR}/${P}.manpage.patch"
)

DOCS=( TODO NEWS CREDITS )

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dodir /usr/bin

	emake \
		MANDIR="${D}usr/share/man/man1" \
		BINDIR="${D}usr/bin/" \
		install

	einstalldocs
}
