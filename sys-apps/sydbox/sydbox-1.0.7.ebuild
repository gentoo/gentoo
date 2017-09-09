# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ptrace-based sandbox"
HOMEPAGE="https://git.exherbo.org/sydbox-1.git"
SRC_URI="http://distfiles.exherbo.org/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug seccomp test"

RDEPEND="sys-libs/pinktrace:=
	debug? ( sys-libs/libunwind:= )"
DEPEND="${RDEPEND}
	test? ( app-portage/unsandbox )"

src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable seccomp)
	)

	econf "${myconf[@]}"
}

src_test() {
	# two sandboxes are never a good idea ;-)
	unsandbox emake check
}
