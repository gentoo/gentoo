# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib

MY_P=${P/.0/}

DESCRIPTION="Xosd plugin for LINEAK"
HOMEPAGE="http://lineak.sourceforge.net/"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND="
	=x11-misc/lineakd-${PV}*
	x11-libs/xosd
"
RDEPEND="
	${DEPEND}
"

S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
)

src_configure() {
	econf \
		$(use_enable debug) \
		--with-lineak-plugindir="${EROOT}/usr/$(get_libdir)/lineakd" \
		--with-x
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PLUGINDIR=/usr/$(get_libdir)/lineakd/plugins \
		install

	dodoc AUTHORS README
}
