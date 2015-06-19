# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/txt2pdbdoc/txt2pdbdoc-1.4.4.ebuild,v 1.10 2013/01/20 15:07:59 scarabeus Exp $

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
