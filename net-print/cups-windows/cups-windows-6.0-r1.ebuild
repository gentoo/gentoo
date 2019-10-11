# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="CUPS PostScript Driver for Windows"
HOMEPAGE="https://www.cups.org/"
SRC_URI="mirror://gentoo/${P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=">=net-print/cups-1.2"
DEPEND="${RDEPEND}"

src_install() {
	emake install BUILDROOT="${D}"
	dodoc README.txt
	einfo "Copying missing cups6.ppd file"
	cp "${S}/i386/cups6.ppd" "${ED}/usr/share/cups/drivers/"
}
