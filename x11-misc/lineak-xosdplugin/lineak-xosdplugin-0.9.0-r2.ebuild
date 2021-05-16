# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/.0/}
DESCRIPTION="Xosd plugin for LINEAK"
HOMEPAGE="http://lineak.sourceforge.net/"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND="
	=x11-misc/lineakd-${PV}*
	x11-libs/xosd
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
)

src_configure() {
	econf \
		$(use_enable debug) \
		--with-lineak-plugindir="${EPREFIX}/usr/$(get_libdir)/lineakd" \
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
