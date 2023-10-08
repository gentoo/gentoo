# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="mac-robber is a digital forensics and incident response tool that collects data"
HOMEPAGE="http://www.sleuthkit.org/mac-robber/index.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

PATCHES=( "${FILESDIR}"/${P}-posix.patch )

src_prepare() {
	default
	# just rely on implicit rules
	rm Makefile || die
}

src_configure() {
	tc-export CC
}

src_compile() {
	emake mac-robber
}

src_install() {
	dobin mac-robber
	einstalldocs
}
