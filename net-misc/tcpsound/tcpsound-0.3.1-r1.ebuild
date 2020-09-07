# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Play sounds in response to network traffic"
LICENSE="BSD"
HOMEPAGE="http://www.ioplex.com/~miallen/tcpsound/"
SRC_URI="http://www.ioplex.com/~miallen/tcpsound/dl/${P}.tar.gz"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/libmba
	media-libs/libsdl
	net-analyzer/tcpdump
"
RDEPEND="${DEPEND}"
DOCS=( README.txt elaborate.conf )
PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-misc.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	gunzip $(find "${ED}" -name '*.[0-9].gz') || die
}
