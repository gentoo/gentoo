# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/pftop/pftop-0.7-r2.ebuild,v 1.1 2012/07/22 00:01:31 the_paya Exp $

EAPI=4
PATCH_PV=3

inherit bsdmk flag-o-matic eutils

DESCRIPTION="Pftop: curses-based utility for real-time display of active states and rule statistics for pf"
HOMEPAGE="http://www.eee.metu.edu.tr/~canacar/pftop/"
SRC_URI="http://www.eee.metu.edu.tr/~canacar/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCH_PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE="altq"

RDEPEND="sys-libs/ncurses"

src_prepare() {
	epatch "${WORKDIR}"/patches/*
}

src_compile() {
	# OS_LEVEL variable refers to the version of pf shipped with OpenBSD.
	# On FreeBSD we have to know it.
	local OSLEVEL

	case ${CHOST} in
		*-openbsd*)
			local obsdver=${CHOST/*-openbsd/}
			OSLEVEL=${obsdver//.}
			;;
		*-freebsd[78]*)	OSLEVEL=41 ;;
		*-freebsd9*)	OSLEVEL=45 ;;
		*)
			die "Your OS/Version is not supported (${CHOST}), please report."
			;;
	esac
	append-flags "-DHAVE_SNPRINTF -DHAVE_VSNPRINTF -DOS_LEVEL=${OSLEVEL}"
	use altq && append-flags "-DHAVE_ALTQ"
	mkmake LOCALBASE="/usr" CFLAGS="${CFLAGS}" || die "pmake failed"
}

src_install() {
	mkinstall DESTDIR="${D}" LOCALBASE="/usr" MANDIR="/usr/share/man/man" \
		NO_MANCOMPRESS= install || die
}
