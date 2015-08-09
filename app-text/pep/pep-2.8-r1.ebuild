# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="General purpose filter and file cleaning program"
HOMEPAGE="http://hannemyr.com/enjoy/pep.html"
SRC_URI="http://hannemyr.com/enjoy/${PN}${PV//./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ppc x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_prepare() {
	# pep does not come with autconf so here's a patch to configure
	# Makefile with the correct path
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-include.patch
	# Darwin lacks stricmp and DIRCHAR
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/^OBJS/s/^\(.*\)$/\1 bdmg.o/' Makefile
		append-flags "-Dunix" -DSTRICMP
	fi
}

src_compile() {
	# make man page too
	make Doc/pep.1 || die "make man page failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin pep || die "dobin failed"
	doman Doc/pep.1 || die "doman failed"

	insinto /usr/share/pep
	doins Filters/* || die "doins failed"

	dodoc aareadme.txt file_id.diz
}
