# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="dockapp that monitors one or more mailboxes"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.2.1-checkthread.patch )
src_prepare() {
	sed -i -e "s/-lssl/\0 -lcrypto/" wmmaiload/Init.make || die
	sed -e "s/SSLv2_client_method/SSLv23_client_method/" \
		-i wmmaiload/ssl.c || die

	default
}

src_configure() {
	# The ./configure script is not autoconf based, therefore don't use econf:
	./configure -p /usr || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		DEBUG_LDFLAGS="" \
		LDFLAGS="${LDFLAGS}" \
		DEBUG_CFLAGS=""
}

src_install() {
	dobin ${PN}/${PN} ${PN}-config/${PN}-config
	doman doc/*.1
	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS TODO doc/sample.${PN}rc
}
