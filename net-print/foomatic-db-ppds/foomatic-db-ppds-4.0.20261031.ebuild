# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="linuxprinting.org PPD files for postscript printers"
HOMEPAGE="https://openprinting.github.io/foomatic/printers"
# Upstream removes the tarball every day: store a copy in our devspace for
# people not relying on our mirrors
SRC_URI="https://www.openprinting.org/download/foomatic/${PN/-ppds}-$(ver_rs 2 -).tar.xz
	https://dev.gentoo.org/~pacho/${PN}/${PN/-ppds}-$(ver_rs 2 -).tar.xz"
S=${WORKDIR}/${PN/-ppds}-$(ver_cut 3)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

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
