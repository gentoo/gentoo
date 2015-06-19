# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/miniupnpc/miniupnpc-1.7.ebuild,v 1.4 2012/12/16 18:16:50 armin76 Exp $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="UPnP client library and a simple UPnP client"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kernel_linux static-libs"

RESTRICT="test" #409349

RDEPEND=""
DEPEND="kernel_linux? ( sys-apps/lsb-release sys-apps/which )"

src_prepare() {
	epatch_user

	sed -i -e '/CFLAGS.*-O/d' Makefile || die
	if ! use static-libs; then
		sed -i \
			-e '/FILESTOINSTALL =/s/ $(LIBRARY)//' \
			-e '/$(INSTALL) -m 644 $(LIBRARY) $(INSTALLDIRLIB)/d' \
			Makefile || die
	fi
}

# Upstream cmake causes more trouble than it fixes,
# so we'll just stay with the Makefile for now.

src_compile() {
	tc-export CC
	emake upnpc-shared $(use static-libs && echo upnpc-static)
}

src_install() {
	emake \
		PREFIX="${D}" \
		INSTALLDIRLIB="${D}usr/$(get_libdir)" \
		install

	dodoc README Changelog.txt
}
