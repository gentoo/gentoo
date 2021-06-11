# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV:2:6}

DESCRIPTION="Utilities for converting between and manipulating mac fonts and unix fonts"
HOMEPAGE="http://fondu.sourceforge.net/"
SRC_URI="http://fondu.sourceforge.net/${PN}_src-${MY_PV}.tgz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${P}-build-fix.patch
)

src_prepare() {
	default

	sed -e 's:^CFLAGS =:CFLAGS +=:' \
		-e 's:$(CFLAGS) -o:$(CFLAGS) $(LDFLAGS) -o:' \
		-e 's:wilprefix:prefix:' \
		-i Makefile.in || die "failed to sed"
}

src_install() {
	default
	doman *.1
}
