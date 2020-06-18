# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="ptrace-based sandbox"
HOMEPAGE="https://git.exherbo.org/sydbox-1.git"
SRC_URI="https://git.exherbo.org/sydbox-1.git/snapshot/${PN}-1-${PV}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug seccomp test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/pinktrace:=
	debug? ( sys-libs/libunwind:= )"
DEPEND="${RDEPEND}
	test? ( !<sys-apps/sandbox-2.13 )"

S="${WORKDIR}/${PN}-1-${PV}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable seccomp)
	)

	econf "${myconf[@]}"
}

src_test() {
	# unload the Gentoo sandbox
	local -x SANDBOX_ON=0
	local -x LD_PRELOAD=

	emake check
}
