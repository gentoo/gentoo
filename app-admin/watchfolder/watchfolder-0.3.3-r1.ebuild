# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Watches directories and processes files"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"
S="${WORKDIR}/${P/folder/d}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~x86"

PATCHES=(
	# patch to remove warnings on 64 bit systems
	"${FILESDIR}"/${PV}-64bit.patch
	# and a gcc 4.3.3 / fortify_sources fix
	"${FILESDIR}"/${PV}-fortify-sources.patch
	# various implicit declarations
	"${FILESDIR}"/${PV}-implicit-decl.patch
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
