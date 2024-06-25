# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/pv.asc
inherit linux-info toolchain-funcs verify-sig

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="https://www.ivarch.com/programs/pv.shtml https://codeberg.org/a-j-wood/pv"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://codeberg.org/a-j-wood/pv"
	inherit autotools git-r3
else
	SRC_URI="
		https://www.ivarch.com/programs/sources/${P}.tar.gz
		verify-sig? ( https://www.ivarch.com/programs/sources/${P}.tar.gz.txt -> ${P}.tar.gz.asc )
	"

	KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug nls"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-pv )"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~SYSVIPC"
		ERROR_SYSVIPC="You will need to enable CONFIG_SYSVIPC in your kernel to use the --remote option."
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default

	# Valgrind isn't reliable within sandbox.
	cat <<-EOF > tests/run-valgrind.sh || die
	#!/bin/sh
	exit 77
	EOF
	chmod +x tests/run-valgrind.sh || Die

	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	tc-export AR

	econf \
		$(use_enable debug debugging) \
		$(use_enable nls)
}

src_test() {
	emake -Onone check
}
