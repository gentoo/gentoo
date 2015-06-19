# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-gazette/linux-gazette-46.ebuild,v 1.10 2015/02/21 04:50:55 mrueg Exp $

EAPI=5

DESCRIPTION="Sharing ideas and discoveries and Making Linux just a little more fun"
HOMEPAGE="http://linuxgazette.net/"
SRC_URI="http://linuxgazette.net/ftpfiles/lg-issue${PV}.tar.gz"

LICENSE="OPL"
SLOT="${PV}"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=">=app-doc/linux-gazette-base-${PV}"

S=${WORKDIR}

src_install() {
	dodir /usr/share/doc
	mv "${WORKDIR}"/lg "${D}"/usr/share/doc/${PN} || die
}
