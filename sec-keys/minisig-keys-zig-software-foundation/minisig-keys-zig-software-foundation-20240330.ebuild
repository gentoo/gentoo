# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Minisign keys used by Zig Software Foundation"

HOMEPAGE="https://ziglang.org/download/"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/minisig-keys
	# Key can be found at ebuild's HOMEPAGE.
	newins - zig-software-foundation.pub <<-EOF
		RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U
	EOF
}
