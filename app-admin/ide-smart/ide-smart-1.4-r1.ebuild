# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A tool to read SMART information from harddiscs"
HOMEPAGE="http://www.linalco.com/comunidad.html http://www.linux-ide.org/smart.html"
SRC_URI="http://www.linalco.com/ragnar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-1.4-fix-build-system.patch )

src_prepare() {
	default

	# yes, the tarball includes pre-compiled
	# object files and binaries
	rm ${PN}{,.o} || die
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin ide-smart
	doman ide-smart.8
	einstalldocs
}
