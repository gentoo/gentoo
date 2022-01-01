# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info toolchain-funcs

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="https://www.ivarch.com/programs/pv.shtml"
SRC_URI="https://www.ivarch.com/programs/sources/${P}.tar.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x86-solaris"
IUSE="debug nls"

PV_LINGUAS=( de fr pl pt )

DOCS=( README doc/NEWS doc/TODO )

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~SYSVIPC"
		ERROR_SYSVIPC="You will need to enable CONFIG_SYSVIPC in your kernel to use the --remote option."
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default

	sed -i configure -e 's|CFLAGS="-g -Wall"|:|g' || die

	# These should produce the same end result (working `pv`).
	sed -i \
		-e 's:$(LD) $(LDFLAGS) -o:$(AR) rc:' \
		autoconf/make/modules.mk~ || die
}

src_configure() {
	tc-export AR
	local lingua
	for lingua in ${PV_LINGUAS[@]}; do
		if ! has ${lingua} ${LINGUAS-${lingua}}; then
			sed -i configure -e "/ALL_LINGUAS=/s:${lingua}::g" || die
		fi
	done
	econf $(use_enable debug debugging) $(use_enable nls)
}

src_test() {
	sed -i -e 's:usleep 200000 || ::g' tests/019-remote-cksum || die
	default
}
