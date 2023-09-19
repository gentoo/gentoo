# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A commandline interface to Microchip's PICSTART+ programmer"
HOMEPAGE="http://home.pacbell.net/theposts/picmicro/"
SRC_URI="http://home.pacbell.net/theposts/picmicro/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-errno.patch
	"${FILESDIR}"/${P}-C99-stdbool.patch
)

src_prepare() {
	default

	# remove stale binaries
	rm picsnoop/{picsnoop,*.o} || die
}

src_configure() {
	tc-export CC
}

src_compile() {
	emake
	emake -C picsnoop
	emake -C fixchksum
}

src_install() {
	dobin picp picsnoop/picsnoop fixchksum/fixchksum

	einstalldocs
	dodoc BugReports.txt HISTORY LICENSE.TXT NOTES PSCOMMANDS.TXT

	newdoc picsnoop/README.TXT PICSNOOP.txt
	newdoc fixchksum/README fixchksum.txt

	docinto html
	dodoc PICPmanual.html
}
