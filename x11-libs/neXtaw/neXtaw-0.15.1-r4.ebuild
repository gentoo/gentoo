# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Athena Widgets with N*XTSTEP appearance"
HOMEPAGE="https://siag.nu/neXtaw/"
SRC_URI="https://siag.nu/pub/neXtaw/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	x11-libs/libxkbfile"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	sys-devel/flex
	virtual/yacc"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x
	append-cflags -fno-strict-aliasing #864535

	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
