# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_COMMIT="a29f692040e6086f5233197444773c36f36cdd9c"

DESCRIPTION="Ping implementation that uses the TCP protocol"
HOMEPAGE="https://github.com/mkirchner/tcping"
SRC_URI="https://github.com/mkirchner/${PN}/tarball/${MY_COMMIT} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/mkirchner-"${PN}"-"${MY_COMMIT:0:7}"

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
