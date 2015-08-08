# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran

inherit eutils fcaps fortran-2 linux-info multilib

DESCRIPTION="A lightweight performance-oriented tool suite for x86 multicore environments"
HOMEPAGE="https://code.google.com/p/likwid/"
SRC_URI="http://ftp.fau.de/pub/likwid/likwid-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-fortran"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	sys-apps/sed"

CONFIG_CHECK="~X86_MSR"

FILECAPS=(
	cap_sys_rawio usr/sbin/likwid-accessD --
	cap_sys_rawio usr/bin/likwid-{perfctr,bench,powermeter}
)

src_prepare() {
	sed -e 's:^PREFIX = .*:PREFIX = '${D}'/usr:' \
		-e "/^LIBLIKWIDPIN/s|lib/|$(get_libdir)/|" \
		-i config.mk || die
	sed -e "s:\$(PREFIX)/lib:\$(PREFIX)/$(get_libdir):" \
		-i Makefile || die

	sed -e '/LIBS/aSHARED_LFLAGS += -Wl,-soname,$@' \
		-i make/include_GCC.mk || die
	sed -e '/^Q/d' -i Makefile || die
	sed -e 's/<DATE>/12.02.2014/g' \
		-e "s/VERSION/${PV}/g" \
		-i doc/* || die
	sed -e "/exeprog/s|TOSTRING(ACCESSDAEMON)|\"/usr/sbin/likwid-accessD\"|" \
		-i src/accessClient.c || die

	epatch "${FILESDIR}/${P}-Makefile.patch"
	epatch "${FILESDIR}/${P}-fix-gnustack.patch"
}

src_configure() {
	if use fortran; then
		sed -i 's:^FORTRAN_INTERFACE = false:FORTRAN_INTERFACE = likwid.mod:' config.mk || die
		sed -i 's:^FC  = ifort:FC  = gfortran:' make/include_GCC.mk || die
		sed -i '/^FCFLAGS/c\FCFLAGS  = -J ./ -fsyntax-only' make/include_GCC.mk || die
	fi
}

src_install () {
	default
	if use fortran; then
		insinto /usr/include
		doins likwid.mod
	fi

	doman doc/*
}
