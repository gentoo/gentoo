# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic

DESCRIPTION="QC compiler"
HOMEPAGE="http://fteqw.sourceforge.net/"
SRC_URI="mirror://sourceforge/fteqw/qclibsrc${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="test"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cleanup-source.patch
	sed -i \
		-e '/^CC/d' \
		-e "s: -O3 : :g" \
		-e "s: -s : :g" \
		-e 's/-o fteqcc.bin/$(LDFLAGS) -o fteqcc.bin/' \
		Makefile || die "sed failed"
	edos2unix readme.txt
	append-flags -DQCCONLY
}

src_compile() {
	emake BASE_CFLAGS="${CFLAGS} -Wall"
}

src_install() {
	newbin fteqcc.bin fteqcc
	dodoc readme.txt
}
