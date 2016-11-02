# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED=fortran

inherit fcaps linux-info toolchain-funcs fortran-2

DESCRIPTION="A performance-oriented tool suite for x86 multicore environments"
HOMEPAGE="https://github.com/rrze-likwid/likwid"
SRC_URI="https://ftp.fau.de/pub/likwid/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fortran"

RDEPEND="dev-lang/perl"

DEPEND="${RDEPEND}
	fortran? ( sys-devel/gcc:*[fortran] )
	dev-lang/lua:0"

CONFIG_CHECK="~X86_MSR"

FILECAPS=(
	-M 755 cap_sys_rawio usr/sbin/likwid-accessD --
	-M 755 cap_sys_rawio usr/bin/likwid-{perfctr,bench,powermeter}
)

# See Bug 558402
PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
	"${FILESDIR}/${P}-fix-gnustack.patch"
	"${FILESDIR}/${P}-config.mk.patch"
)

src_prepare() {
	# Set PREFIX path to include sandbox path
	sed -e 's:^PREFIX = .*:PREFIX = '${D}'/usr:' -i config.mk || \
		die "Failed to set correct prefix path"

	# Set the path to library directory.
	sed -e 's:$(get_libdir):'$(get_libdir)':' -i config.mk || \
		die "Cannot set library path!"

	# Set correct LDFLAGS
	sed -e '/LIBS/aSHARED_LFLAGS += -Wl,-soname,$@' \
		-i make/include_GCC.mk || die "Failed to set correct LDFLAGS"

	# Insert date and version info man pages
	sed -e 's/<DATE>/21.08.2015/g' \
		-e "s/VERSION/${PV}/g" \
		-i doc/*.1 || die "Failed to insert date into man pages"

	# Set path to the access daemon, once installed into the system
	sed -e "/exeprog/s|TOSTRING(ACCESSDAEMON)|\"/usr/sbin/likwid-accessD\"|" \
		-i src/access_client.c || die "Failed to set access daemon path"

	# Ensure we build with a non executable stack
	sed -e "s:\$(SHARED_CFLAGS): \$(SHARED_CFLAGS)  -Wa,--noexecstack:" \
	        -i make/config_defines.mk || die "Failed to set nonexecstack"

	if use fortran; then

		# If fortran USE is enabled, enable the fortran interfaces
		sed -i 's:^FORTRAN_INTERFACE = false:FORTRAN_INTERFACE = likwid.mod:' \
			config.mk || die "Enabling of fortran failed"

		# Set the correct fortran compiler for GCC
		sed -i "s:^FC  = ifort:FC = ${FC}:" make/include_GCC.mk \
			|| die "Failed to set fortran compiler"

		# Set the correct FCFLAGS for gcc fortran
		sed -i '/^FCFLAGS/c\FCFLAGS = -J ./ -fsyntax-only' make/include_GCC.mk \
			|| die "Failed to set GCC flags for fortran"
	fi

	# Respect CC
	sed -e "s:^CC.*:CC = $(tc-getCC):" \
		-i make/include_GCC.mk || die

	default

}

src_install () {
	default
	if use fortran; then
		insinto /usr/include
		doins likwid.mod
	fi

	doman doc/*.1
}

pkg_postinst() {
	fcaps_pkg_postinst
	ewarn "To enable users to access performance counters it is necessary to"
	ewarn "change the access permissions to /dev/cpu/msr[0]* devices."
	ewarn "It can be accomplished by adding the following line to file"
	ewarn "/etc/udev/rules.d/99-myrules.rules: KERNEL==\"msr[0-9]*\" MODE=\"0666\""
}
