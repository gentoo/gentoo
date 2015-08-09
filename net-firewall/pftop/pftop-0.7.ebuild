# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

PATCH_PV=1

inherit bsdmk flag-o-matic eutils

DESCRIPTION="Pftop: curses-based utility for real-time display of active states and rule statistics for pf"
HOMEPAGE="http://www.eee.metu.edu.tr/~canacar/pftop/"
SRC_URI="http://www.eee.metu.edu.tr/~canacar/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCH_PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/ncurses"

src_unpack() {
	unpack ${A}
	cd "${S}"
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
		*-freebsd5.[34])	OSLEVEL=35 ;;
		*-freebsd6.[012])	OSLEVEL=37 ;;
		*-freebsd*)		OSLEVEL=41 ;;
		*)
			die "Your OS/Version is not supported (${CHOST}), please report."
			;;
	esac
	append-flags "-DHAVE_SNPRINTF -DHAVE_VSNPRINTF -DOS_LEVEL=${OSLEVEL}"
	mkmake LOCALBASE="/usr" CFLAGS="${CFLAGS}" || die "pmake failed"
}

src_install() {
	mkinstall DESTDIR="${D}" LOCALBASE="/usr" MANDIR="/usr/share/man/man" \
		NO_MANCOMPRESS= install || die
}
