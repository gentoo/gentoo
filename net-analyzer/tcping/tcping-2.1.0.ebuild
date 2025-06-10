# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Check if a desired port is reachable via TCP"
HOMEPAGE="https://github.com/mkirchner/tcping"
SRC_URI="https://github.com/mkirchner/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

src_prepare() {
	default
	sed -e '/^CC=/s:=:?=:' \
		-e '/^CCFLAGS/s:=:+=:' \
		-e 's/$(CCFLAGS)/$(CCFLAGS) $(LDFLAGS)/' \
		-i Makefile || die
	tc-export CC
	export CCFLAGS="${CFLAGS}"
}

src_install() {
	dobin tcping
	dodoc README
}
