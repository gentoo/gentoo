# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="watches directories and processes files"
HOMEPAGE="http://freshmeat.net/projects/watchd/"
SRC_URI="http://dstunrea.sdf-eu.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~x86"

S="${WORKDIR}/${P/folder/d}"

PATCHES=(
	# patch to remove warnings on 64 bit systems
	"${FILESDIR}"/${PV}-64bit.patch
	# and a gcc 4.3.3 / fortify_sources fix
	"${FILESDIR}"/${PV}-fortify-sources.patch
)

src_prepare() {
	default
	sed -i \
		-e '/-c -o/s:OPT:CFLAGS:' \
		-e 's:(\(LD\)\?OPT):(LDFLAGS) $(CFLAGS):' \
		-e 's:gcc:$(CC):' \
		Makefile || die "sed Makefile failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin watchd
	insinto /etc
	doins watchd.conf
	dodoc README doc/*
}
