# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmpiki/wmpiki-0.2.1.ebuild,v 1.11 2014/08/10 20:08:32 slyfox Exp $

EAPI=2
inherit eutils

IUSE=""

DESCRIPTION="Wmpiki is a dockapp which checks and displays small leds for indicate hosts activity"
HOMEPAGE="http://clay.ll.pl/projects.html#dockapps"
SRC_URI="http://clay.ll.pl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=sys-apps/sed-4.1.4-r1"

src_prepare()
{
	sed -i 's/gcc/${CC}/' Makefile
	sed -i 's/-o wmpiki/${LDFLAGS} -o wmpiki/' Makefile
}

src_compile()
{
	make CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "Compilation failed"
}

src_install()
{
	dobin wmpiki
	dodoc AUTHORS ChangeLog README config.example
}

pkg_postinst()
{
	einfo "Don't forget to edit wmpiki configuration file:"
	einfo "~/.clay/wmpiki"
}
