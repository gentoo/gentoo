# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs

DESCRIPTION="Stress test for a computer system with various selectable ways"
HOMEPAGE="https://github.com/ColinIanKing/stress-ng"
SRC_URI="https://github.com/ColinIanKing/${PN}/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-libs/libaio
	dev-libs/libbsd
	dev-libs/libgcrypt:0=
	sys-apps/attr
	sys-apps/keyutils:=
	sys-libs/libcap
	sys-libs/zlib
	virtual/libcrypt:=
"

RDEPEND="${DEPEND}"

DOCS=( "README.md" "README.Android" "TODO" "syscalls.txt" )

src_compile() {
	export MAN_COMPRESS=0
	export VERBOSE=1
	tc-export CC

	default
}

pkg_postinst() {
	optfeature "AppArmor support" sys-libs/libapparmor
	optfeature "SCTP support" net-misc/lksctp-tools
}
