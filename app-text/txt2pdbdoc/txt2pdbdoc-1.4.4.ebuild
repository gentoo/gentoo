# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Text/HTML to Doc file converter for the Palm Pilot"
HOMEPAGE="http://homepage.mac.com/pauljlucas/software/txt2pdbdoc/"
SRC_URI="http://homepage.mac.com/pauljlucas/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README ChangeLog )

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.4-implicit-decl-getopt.patch
)

src_prepare() {
	default

	sed -i -e "/^CFLAGS/d" configure.in || die
	mv configure.{in,ac} || die

	eautoreconf
}
