# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib toolchain-funcs

DESCRIPTION="A preload (sandbox) library to restrict filesystem writes"
HOMEPAGE="http://dag.wieers.com/home-made/soapbox/"
SRC_URI="http://dag.wieers.com/home-made/soapbox/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc ~ppc64"
IUSE=""

src_prepare() {
	sed -i soapbox.sh \
		-e "s|0.3.0|${PV}|g" \
		-e "s:/lib:/usr/$(get_libdir):" \
		|| die "sed soapbox.sh"
	sed -i Makefile \
		-e 's|$(CFLAGS)|& $(LDFLAGS)|g' \
		|| die "sed Makefile"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -fPIC" \
		LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dolib.so libsoapbox.so || die "soapsox.so"
	newbin soapbox.sh soapbox || die "soapbox"
	dodoc AUTHORS BUGS ChangeLog README THANKS TODO
}
