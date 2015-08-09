# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="ethernet program loader for the Dreamcast"
HOMEPAGE="http://cadcdev.sourceforge.net/"
SRC_URI="mirror://sourceforge/cadcdev/dcload-ip-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

S=${WORKDIR}/dcload-ip-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-bfd-update.patch
	epatch "${FILESDIR}"/${P}-headers.patch
	append-cppflags -DPACKAGE -DPACKAGE_VERSION #465952
	sed -i \
		-e "/^HOSTCC/s:gcc:$(tc-getCC):" \
		-e "/^HOSTCFLAGS/s:-O2:${CFLAGS} ${CPPFLAGS}:" \
		-e 's:-L/usr/local/dcdev/lib:$(LDFLAGS):' \
		-e 's:/usr/local/dcdev/include:.:' \
		Makefile.cfg || die "sed"
}

src_compile() {
	emake -C host-src/tool
}

src_install() {
	dobin host-src/tool/dc-tool
	dodoc README NETWORK CHANGES
	dodoc -r make-cd
	if use doc ; then
		dodoc -r example-src
	fi
}
