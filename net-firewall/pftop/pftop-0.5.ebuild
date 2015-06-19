# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/pftop/pftop-0.5.ebuild,v 1.3 2006/10/22 21:17:41 the_paya Exp $

inherit bsdmk
DESCRIPTION="Pftop: curses-based utility for real-time display of active states and rule statistics for pf"

HOMEPAGE="http://www.eee.metu.edu.tr/~canacar/pftop/"

SRC_URI="http://www.eee.metu.edu.tr/~canacar/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/ncurses"

src_compile() {
	# OS_LEVEL variable refers to the version of pf shipped with OpenBSD.
	# On FreeBSD we have to know it.
	local OSLEVEL

	case ${CHOST} in
		*-openbsd*)
			local obsdver=${CHOST/*-openbsd/}
			OSLEVEL=${obsdver//.}
			;;
		*-freebsd5.[34])	OSLEVEL=35 ;;
		*-freebsd6.[012])	OSLEVEL=37 ;;
		*)
			die "Your OS/Version is not supported (${CHOST}), please report."
			;;
	esac

	mkmake LOCALBASE="/usr" CFLAGS="${CFLAGS} -DOS_LEVEL=${OSLEVEL}" || die "pmake failed"
}

src_install() {
	mkinstall DESTDIR=${D} LOCALBASE="/usr" MANDIR="/usr/share/man/man" install || die
}
