# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils xdg

DESCRIPTION="Dali Clock is a digital clock. When a digit changes, it melts into its new shape"
HOMEPAGE="https://www.jwz.org/xdaliclock"
SRC_URI="https://www.jwz.org/xdaliclock/${P}.tar.gz"
S="${WORKDIR}"/${P}/X11

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/libX11
	virtual/opengl
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/xdaliclock-2.47-DESTDIR.patch
)

src_install() {
	dodir /usr/bin /usr/share/pixmaps
	dodir /usr/share/glib-2.0/schemas /usr/share/man/man1/
	dodir /usr/share/applications/

	default

	# Will collide with dev-libs/glib
	rm "${ED}"/usr/share/glib-2.0/schemas/gschemas.compiled || die

	#dobin ${PN}
	#newman ${PN}.man ${PN}.1
	#dodoc ../README

	#doicon xdaliclock.png
	#domenu xdaliclock.desktop
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
