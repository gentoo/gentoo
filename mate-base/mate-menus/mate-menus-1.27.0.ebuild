# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
else
	KEYWORDS=""
fi

DESCRIPTION="MATE menu system, implementing the F.D.O cross-desktop spec"
LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="debug +introspection nls"

COMMON_DEPEND=">=dev-libs/glib-2.50:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"

RDEPEND="${COMMON_DEPEND}"

BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
DEPEND="${COMMON_DEPEND}"

src_configure() {
	# Do NOT compile with --disable-debug/--enable-debug=no as it disables API
	# usage checks.
	mate_src_configure \
		--enable-debug=$(usex debug yes) \
		$(use_enable introspection) \
		$(use_enable nls)
}

src_install() {
	mate_src_install

	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/10-xdg-menu-mate-r1" "10-xdg-menu-mate"
}
