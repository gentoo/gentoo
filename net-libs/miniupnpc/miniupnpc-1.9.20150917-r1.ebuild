# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="UPnP client library and a simple UPnP client"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/14"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="ipv6 kernel_linux static-libs"

RDEPEND=""
DEPEND="kernel_linux? ( sys-apps/lsb-release sys-apps/which )"

src_prepare() {
	epatch_user

	# These bins are not installed, upnpc-static requires building static lib
	sed -i -e '/EXECUTABLES =/s/ upnpc-static listdevices//' Makefile || die

	if ! use static-libs; then
		sed -i \
			-e '/FILESTOINSTALL =/s/ $(LIBRARY)//' \
			-e '/$(INSTALL) -m 644 $(LIBRARY) $(DESTDIR)$(INSTALLDIRLIB)/d' \
			Makefile || die
	fi
}

# Upstream cmake causes more trouble than it fixes,
# so we'll just stay with the Makefile for now.

src_compile() {
	tc-export CC AR
	emake upnpc-shared $(use static-libs && echo upnpc-static)
}

src_test() {
	emake -j1 HAVE_IPV6=$(usex ipv6 yes no) check
}

src_install() {
	emake \
		PREFIX="${D}" \
		INSTALLDIRLIB="${D}usr/$(get_libdir)" \
		install

	# oh no, a missing header! fixed upstream:
	# https://github.com/miniupnp/miniupnp/commit/1315c473539d03
	insinto /usr/include/miniupnpc
	doins upnpdev.h

	dodoc README Changelog.txt
}
