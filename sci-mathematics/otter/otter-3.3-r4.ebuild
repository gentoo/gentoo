# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="An Automated Deduction System"
HOMEPAGE="http://www.cs.unm.edu/~mccune/otter/"
SRC_URI="http://www.cs.unm.edu/~mccune/otter/${P}.tar.gz"

LICENSE="otter"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gold.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	append-cflags -fcommon
	append-cflags -std=gnu89 # old codebase, incompatible with c2x
	append-cppflags -D_GNU_SOURCE #871423 (gethostname, caddr_t)
}

src_compile() {
	tc-export AR CC

	emake -C source
	emake -C mace2
}

src_install() {
	dobin bin/* source/formed/formed

	dodoc README* Legal Changelog Contents documents/*.pdf

	insinto /usr/share/${PN}
	doins -r examples examples-mace2
}
