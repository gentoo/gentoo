# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils multilib

MY_P=${P/.0/}

DESCRIPTION="Linux support for Easy Access and Internet Keyboards"
HOMEPAGE="http://lineak.sourceforge.net"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="debug"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libxkbfile
	x11-libs/libXt
	x11-libs/libXtst
"

S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-DELL-XPS-M1330-XOrg-1_5.patch
)

src_configure() {
	econf $(use_enable debug) --with-x
}

src_install() {
	sed -i -e 's:$(DESTDIR)${DESTDIR}:$(DESTDIR):' lineakd/Makefile

	dodir /usr/share/man/man8

	emake -j1 DESTDIR="${D}" install

	prune_libtool_files

	dodoc AUTHORS README TODO

	keepdir /usr/$(get_libdir)/lineakd/plugins

	insinto /etc/lineak
	doins lineakd.conf.example lineakd.conf.kde.example
}
