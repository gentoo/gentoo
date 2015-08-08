# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Text/HTML to Doc file converter for the Palm Pilot"
HOMEPAGE="http://homepage.mac.com/pauljlucas/software/txt2pdbdoc/"
SRC_URI="http://homepage.mac.com/pauljlucas/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README ChangeLog )

src_prepare() {
	sed -i -e "/^CFLAGS/d" configure.in
	eautoreconf
}
