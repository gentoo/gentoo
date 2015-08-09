# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

IUSE="high-ints"
DESCRIPTION="a dockapp to monitor: CPU, Memory, Uptime, IRQs, Paging and Swap activity"
SRC_URI="http://www.gnugeneration.com/software/wmsysmon/src/${P}.tar.gz
	mirror://gentoo/${P}-s4t4n.patch.bz2"
HOMEPAGE="http://www.gnugeneration.com/software/wmsysmon/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=sys-apps/sed-4.1.5-r1"

src_unpack()
{
	unpack ${A}
	cd "${S}"

	# bug 48851
	epatch "${WORKDIR}"/${P}-s4t4n.patch

	# Monitor all the 24 interrupts on alpha and x86 SMP machines
	if use alpha || use high-ints; then
		cd src
		epatch "${FILESDIR}"/${PN}-high-ints.patch
	fi

	# Do no strip binaries during compilation, see bug #252113
	sed -i 's/LDFLAGS += -lXpm -lXext -lX11 -lm -s/LDFLAGS += -lXpm -lXext -lX11 -lm/' "src/Makefile"
}

src_compile()
{
	GENTOO_CFLAGS="${CFLAGS}" make -C src
}

src_install ()
{
	dobin src/wmsysmon
	dodoc ChangeLog README
}
