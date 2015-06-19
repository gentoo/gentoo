# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/netrik/netrik-1.16.1-r1.ebuild,v 1.6 2014/08/10 20:10:36 slyfox Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="A text based web browser with no ssl support"
HOMEPAGE="http://netrik.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND=">=sys-libs/ncurses-5.1[unicode]
	sys-libs/readline"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "/^doc_DATA/s/COPYING LICENSE //" \
		Makefile.am || die 'sed on Makefile.am failed'

	# bug #467812
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' \
		configure.ac || die 'sed on configure.ac failed'

	# bug #459660
	epatch "${FILESDIR}/${P}-ncurses-tinfo.patch"
	epatch "${FILESDIR}/${P}-configure.patch"
	epatch_user

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install
}
