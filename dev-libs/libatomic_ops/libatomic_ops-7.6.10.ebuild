# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="https://github.com/ivmai/libatomic_ops/"
SRC_URI="https://github.com/ivmai/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT boehm-gc GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
