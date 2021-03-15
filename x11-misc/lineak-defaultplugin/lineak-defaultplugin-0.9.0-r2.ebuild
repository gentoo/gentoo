# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib

MY_P=${P/.0/}

DESCRIPTION="Mute/unmute and other macros for LINEAK"
HOMEPAGE="http://lineak.sourceforge.net"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

RDEPEND="
	=x11-misc/lineakd-${PV}*
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
S=${WORKDIR}/${MY_P}
DOCS=(
	AUTHORS README
)
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc47.patch
)

src_prepare() {
	default

	sed -i -e 's:$(DESTDIR)${DESTDIR}:$(DESTDIR):' default_plugin/Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable debug) \
		--with-lineak-plugindir="${EROOT}/usr/$(get_libdir)/lineakd" \
		USER_LDFLAGS="${LDFLAGS}"
}
