# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit flag-o-matic eutils autotools

DESCRIPTION="A simple command-line interface to the net-dns/hesiod service library"
HOMEPAGE="ftp://athena-dist.mit.edu/pub/ATHENA/hesiod"
SRC_URI="ftp://athena-dist.mit.edu/pub/ATHENA/hesiod/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=net-dns/hesiod-${PV}"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -f aclocal.m4 || die "rm failed"
	epatch "${FILESDIR}/${P}-autotools.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc NEWS README || die
}
