# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils toolchain-funcs

MY_PV=${PV//_p/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Resource-specific view of processes"
HOMEPAGE="http://www.atoptool.nl/"
SRC_URI="http://www.atoptool.nl/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~mips ppc ~ppc64 x86"
IUSE=""

DEPEND="sys-process/acct"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e '/^CFLAGS/s: = -O : += :' \
		-e '/^LDFLAGS/s: = : += :' \
		-e 's:\<cc\>:$(CC):' \
		Makefile
	tc-export CC
	cp "${FILESDIR}"/atop.rc atop.init
	chmod a+rx atop.init
	sed -i 's: root : :' atop.cron #191926
}

src_install() {
	emake DESTDIR="${D}" INIPATH=/etc/init.d install || die
	# useless -${PV} copies ?
	rm -f "${D}"/usr/bin/atop*-${PV}
	dodoc README "${D}"/etc/cron.d/*
	rm -r "${D}"/etc/cron.d || die
}
