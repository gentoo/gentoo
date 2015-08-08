# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Watches directories and processes files, similar to the watchfolder option of Acrobat Distiller"
HOMEPAGE="http://freshmeat.net/projects/watchd/"
SRC_URI="http://dstunrea.sdf-eu.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""
DEPEND=""

S="${WORKDIR}/${P/folder/d}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# patch to remove warnings on 64 bit systems
	epatch "${FILESDIR}"/${PV}-64bit.patch || die
	# and a gcc 4.3.3 / fortify_sources fix
	epatch "${FILESDIR}"/${PV}-fortify-sources.patch || die

	sed -i \
		-e '/-c -o/s:OPT:CFLAGS:' \
		-e 's:(\(LD\)\?OPT):(LDFLAGS) $(CFLAGS):' \
		-e 's:gcc:$(CC):' \
		Makefile || die "sed Makefile failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin watchd || die "dobin failed"
	insinto /etc
	doins watchd.conf
	dodoc README doc/*
}
