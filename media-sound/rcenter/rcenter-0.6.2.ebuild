# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Rcenter - A program to control the EMU10K Remote Control"
HOMEPAGE="http://rooster.stanford.edu/~ben/projects/rcenter.php"
SRC_URI="http://rooster.stanford.edu/~ben/projects/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
#-sparc: emu10k1 doesn't get recognized on sparc hardware
KEYWORDS="amd64 -sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-Wimplicit-function-declaration.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin rcenter
	fperms 755 /usr/bin/rcenter

	insinto /usr/share/rcenter
	doins -r config

	dodoc HISTORY README
}

pkg_postinst() {
	elog "Rcenter Installed  - However You need to setup the scripts"
	elog "for making remote control commands actually work"
	elog
	elog "The Skel scripts can be copied from ${EROOT}/usr/share/rcenter/config to <user>/.rcenter"
	elog "Where <user> is a person who will use rcenter"
	elog "Remeber to use emu-config -i to turn on the remote"
}
