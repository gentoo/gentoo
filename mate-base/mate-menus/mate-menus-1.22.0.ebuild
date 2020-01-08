# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="MATE menu system, implementing the F.D.O cross-desktop spec"
LICENSE="GPL-2 LGPL-2"
SLOT="0"

IUSE="debug +introspection"

COMMON_DEPEND=">=dev-libs/glib-2.50:2
	virtual/libintl
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_configure() {
	# Do NOT compile with --disable-debug/--enable-debug=no as it disables API
	# usage checks.
	mate_src_configure \
		--enable-debug=$(usex debug yes minimum) \
		$(use_enable introspection)
}

src_install() {
	mate_src_install

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-xdg-menu-mate"
}

pkg_postinst() {
	mate_pkg_postinst
	einfo "Due to upstream bug"
	einfo "https://github.com/mate-desktop/mate-menus/issues/2,"
	einfo "it is highly recommended to run the following command"
	einfo "once you have logged in to your desktop for the first time:"
	einfo "cd ~/.config/menus && ln -s {,mate-}applications-merged"
}
