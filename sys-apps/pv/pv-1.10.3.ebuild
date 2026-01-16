# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/pv.asc
inherit linux-info toolchain-funcs verify-sig

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="https://ivarch.com/p/pv https://codeberg.org/ivarch/pv"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://codeberg.org/ivarch/pv"
	inherit autotools git-r3
else
	SRC_URI="
		https://ivarch.com/s/${P}.tar.gz
		verify-sig? ( https://ivarch.com/s/${P}.tar.gz.txt -> ${P}.tar.gz.asc )
	"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug ncurses nls"

RDEPEND="ncurses? ( sys-libs/ncurses:= )"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-pv-20251012 )"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~SYSVIPC"
		ERROR_SYSVIPC="You will need to enable CONFIG_SYSVIPC in your kernel to use the --remote option."
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default

	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	tc-export AR

	econf \
		$(use_enable debug debugging) \
		$(use_with ncurses) \
		$(use_enable nls)
}

src_test() {
	# Valgrind is unreliable within sandbox
	local -x SKIP_VALGRIND_TESTS=1
	emake -Onone check
}
