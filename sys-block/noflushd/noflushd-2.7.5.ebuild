# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A daemon to spin down your disks and force accesses to be cached"
HOMEPAGE="http://noflushd.sourceforge.net/"
SRC_URI="mirror://sourceforge/noflushd/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_compile() {
	econf \
		--with-docdir=/usr/share/doc/${PF} \
		--with-initdir=/etc/init.d
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc NEWS
	prepalldocs

	newinitd "${FILESDIR}"/noflushd.rc6 noflushd
	newconfd "${FILESDIR}"/noflushd.confd noflushd
}

pkg_postinst() {
	ewarn "noflushd works with IDE devices only."
	ewarn "It has possible problems with reiserfs, too."
}
