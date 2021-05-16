# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CUPS PostScript Driver for Windows"
HOMEPAGE="https://www.cups.org/"
SRC_URI="mirror://gentoo/${P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND=">=net-print/cups-1.2"
DEPEND="${RDEPEND}"

src_install() {
	emake BUILDROOT="${D}" install
	dodoc README.txt

	einfo "Copying missing cups6.ppd file"
	insinto /usr/share/cups/drivers
	doins i386/cups6.ppd
}
