# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/makepp/makepp-1.40.1a.ebuild,v 1.2 2009/10/12 17:50:37 ssuominen Exp $

inherit eutils

DESCRIPTION="GNU make replacement"
HOMEPAGE="http://makepp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.6.0"

S=${WORKDIR}/${P%.*}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-install.patch
	# remove ones which cause sandbox violations
	rm makepp_tests/wildcard_repositories.test
}

src_compile() {
	# not an autoconf configure script
	./configure \
		--prefix=/usr \
		--bindir=/usr/bin \
		--htmldir=/usr/share/doc/${PF}/html \
		--mandir=/usr/share/man \
		--datadir=/usr/share/makepp \
		|| die "configure failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog README
}
