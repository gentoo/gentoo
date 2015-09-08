# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran

inherit eutils fcaps linux-info multilib fortran-2

DESCRIPTION="A performance-oriented tool suite for x86 multicore environments"
HOMEPAGE="https://github.com/rrze-likwid/likwid"
# Upstream have made a habit of making changes to the tagged realesed tarball
SRC_URI="https://dev.gentoo.org/~idella4/tarballs/likwid-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fortran"

RDEPEND="dev-lang/perl"

DEPEND="${RDEPEND}
	sys-apps/sed
	fortran? ( sys-devel/gcc:*[fortran] )
	dev-lang/lua:0"

RESTRICT="mirror"

CONFIG_CHECK="~X86_MSR"

FILECAPS=(
	cap_sys_rawio usr/sbin/likwid-accessD --
	cap_sys_rawio usr/bin/likwid-{perfctr,bench,powermeter}
)

S=${WORKDIR}/likwid-likwid-${PV}

src_prepare() {
	# See Bug 558402
	epatch "${FILESDIR}"/${P}-Makefile.patch \
			"${FILESDIR}"/${P}-fix-gnustack.patch \
			"${FILESDIR}"/${P}-lua-makefile.patch \
			"${FILESDIR}"/${P}-config.mk.patch

	# Set PREFIX path to include sandbox path
	sed -e 's:^PREFIX = .*:PREFIX = '${D}'/usr:' -i config.mk || die

	# Set correct LDFLAGS
	sed -e '/LIBS/aSHARED_LFLAGS += -Wl,-soname,$@' \
		-i make/include_GCC.mk || die

	# Insert date and version info man pages
	sed -e 's/<DATE>/21.08.2015/g' \
		-e "s/VERSION/${PV}/g" \
		-i doc/*.1 || die

	# Set path to the access daemon, once installed into the system
	sed -e "/exeprog/s|TOSTRING(ACCESSDAEMON)|\"/usr/sbin/likwid-accessD\"|" \
		-i src/accessClient.c || die

	# Ensure we build with a non executable stack
	sed -e "s:CFLAGS += \$(SHARED_CFLAGS):CFLAGS += \$(SHARED_CFLAGS) -g -Wa,--noexecstack:" \
	        -i make/config_defines.mk || die

	if use fortran; then

		# If fortran USE is enabled, enable the fortran interfaces
		sed -i 's:^FORTRAN_INTERFACE = false:FORTRAN_INTERFACE = likwid.mod:' config.mk || die

		# Set the correct fortrant compiler for GCC
		sed -i "s:^FC  = ifort:FC = ${FC}:" make/include_GCC.mk || die

		# Set the correct FCFLAGS for gcc fortran
		sed -i '/^FCFLAGS/c\FCFLAGS  = -J ./ -fsyntax-only' make/include_GCC.mk || die
	fi

}

src_install () {
	default
	if use fortran; then
		insinto /usr/include
		doins likwid.mod
	fi

	doman doc/*.1
}
