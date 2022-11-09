# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="General purpose filter and file cleaning program"
HOMEPAGE="https://hannemyr.com/enjoy/pep.html"
SRC_URI="https://hannemyr.com/enjoy/${PN}${PV//./}.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86 ~x86-linux ~ppc-macos"

BDEPEND="app-arch/unzip"

# pep does not come with autoconf so here's a patch to configure
# Makefile with the correct path
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-Fix-Wimplicit-int.patch
)

src_prepare() {
	default

	# Darwin lacks stricmp and DIRCHAR
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/^OBJS/s/^\(.*\)$/\1 bdmg.o/' Makefile || die
		append-flags "-Dunix" -DSTRICMP
	fi
}

src_compile() {
	# make man page too
	emake Doc/pep.1
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin pep
	doman Doc/pep.1

	insinto /usr/share/pep
	doins Filters/*

	dodoc aareadme.txt file_id.diz
}
