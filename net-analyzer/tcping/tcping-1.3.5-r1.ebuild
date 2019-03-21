# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Ping implementation that uses the TCP protocol"
HOMEPAGE="https://github.com/mkirchner/tcping"
SRC_URI="https://web.archive.org/web/20160316191549/http://linuxco.de/tcping/tcping-1.3.5.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
