# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="linuxprinting.org PPD files for postscript printers"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI="http://linuxprinting.org/download/foomatic/${PN/-ppds}-$(ver_rs 2 -).tar.xz"
S=${WORKDIR}/${PN/-ppds}-$(ver_cut 3)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}/Makefile.in-4.0.20120117.patch"
)

src_prepare() {
	rm db/source/PPD/Kyocera/ReadMe.htm || die # bug #559008
	default
}

src_install() {
	default
	rm -v "${ED}"/usr/share/foomatic/xmlschema/{driver,option,printer,types}.xsd || die "Cannot remove duplicates"
}
