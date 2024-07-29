# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Adds support for several speech synthesizers to emacspeak"
HOMEPAGE="http://leb.net/blinux/"
SRC_URI="http://leb.net/pub/blinux/emacspeak/blinux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=app-accessibility/emacspeak-18"

PATCHES=(
	"${FILESDIR}"/gentoo-apollo-fix.patch
)

src_prepare() {
	default
	tc-export CC
}

src_install() {
	emake \
		prefix="${ED}"/usr \
		man1dir="${ED}"/usr/share/man/man1 \
		install
	dodoc CREDITS ChangeLog OtherSynthesizers TODO TROUBLESHOOTING README*
}
