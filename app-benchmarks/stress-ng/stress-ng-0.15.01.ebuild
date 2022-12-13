# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="Stress test for a computer system with various selectable ways"
HOMEPAGE="https://github.com/ColinIanKing/stress-ng"
SRC_URI="https://github.com/ColinIanKing/${PN}/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="apparmor sctp"

DEPEND="
	dev-libs/libaio
	dev-libs/libbsd
	dev-libs/libgcrypt:0=
	sys-apps/attr
	sys-apps/keyutils:=
	sys-libs/libcap
	sys-libs/zlib
	virtual/libcrypt:=
	apparmor? (
		sys-apps/apparmor-utils
		sys-libs/libapparmor
	)
	sctp? ( net-misc/lksctp-tools )
"

RDEPEND="${DEPEND}"

DOCS=( "README.md" "README.Android" "TODO" "syscalls.txt" )

pkg_pretend() {
	if use apparmor; then
		CONFIG_CHECK="SECURITY_APPARMOR"
		check_extra_config
	fi
}

src_compile() {
	tc-export CC

	export MAN_COMPRESS="0"

	local myemakeopts=(
		HAVE_APPARMOR="$(usex apparmor 1 0)"
		HAVE_LIB_SCTP="$(usex sctp 1 0)"
		VERBOSE="1"
	)

	emake "${myemakeopts[@]}"
}
