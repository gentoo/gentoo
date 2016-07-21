# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="A somewhat comprehensive collection of Danish Linux man pages"
HOMEPAGE="http://www.sslug.dk/locale/man-sider/"
SRC_URI="http://www.sslug.dk/locale/man-sider/manpages-da-${PV}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"

S=${WORKDIR}/manpages-da-${PV}

src_compile() { :; }

src_install() {
	dodir /usr/share/man
	emake install-data PREFIX="${D}"/usr/share
	dodoc AUTHORS ChangeLog
}
