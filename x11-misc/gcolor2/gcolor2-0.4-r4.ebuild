# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg

DESCRIPTION="A GTK+ color selector"
HOMEPAGE="http://gcolor2.sourceforge.net"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~pacho/gnome/${PN}.svg"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND=">=x11-libs/gtk+-2.4:2"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.27
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/modular-rgb.patch
	"${FILESDIR}"/${P}-amd64.patch
	"${FILESDIR}"/${P}-pkg-config-macro.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	xdg_src_prepare

	# To check at each bump.
	sed "s/^#.*/[encoding: UTF-8]/" -i po/POTFILES.in || die "sed failed"
	echo "gcolor2.glade" >> po/POTFILES.in || die

	eautoreconf
}

src_install() {
	default

	# Icon from https://sourceforge.net/p/gcolor2/patches/5/
	doicon -s scalable "${DISTDIR}/${PN}.svg"
	make_desktop_entry ${PN} Gcolor2 ${PN} Graphics
}
