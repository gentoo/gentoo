# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-gazette-base/linux-gazette-base-182.ebuild,v 1.1 2011/03/09 07:16:59 vapier Exp $

# the SRC_URI always has the same file name ... make sure you
# `rm ${DISTDIR}/lg-base.tar.gz` and make a new digest with
# every version bump

DESCRIPTION="Linux Gazette - common files"
HOMEPAGE="http://linuxgazette.net/"
SRC_URI="mirror://gentoo/lg-base-${PV}.tar.gz"
#SRC_URI="http://linuxgazette.net/ftpfiles/lg-base.tar.gz"

LICENSE="OPL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}/lg

src_install() {
	dodir /usr/share/doc/linux-gazette
	mv * "${D}"/usr/share/doc/linux-gazette/ || die
}
