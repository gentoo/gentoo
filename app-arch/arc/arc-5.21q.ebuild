# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Create & extract files from DOS .ARC files"
HOMEPAGE="https://arc.sourceforge.net"
SRC_URI="https://github.com/ani6al/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${PN}-5.21m-darwin.patch
	"${FILESDIR}"/${PN}-5.21m-gentoo-fbsd.patch
	"${FILESDIR}"/${PN}-5.21p-fno-common.patch
	"${FILESDIR}"/${PN}-5.21p-variadic-arcdie.patch
)

src_prepare() {
	default

	sed -i Makefile \
		-e 's/CFLAGS = $(OPT) $(SYSTEM)/CFLAGS += $(SYSTEM)/' \
		|| die "sed Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" OPT="${LDFLAGS}"
}

src_install() {
	dobin arc marc
	doman arc.1
	dodoc Arc521.doc Arcinfo Changelog Readme
}
