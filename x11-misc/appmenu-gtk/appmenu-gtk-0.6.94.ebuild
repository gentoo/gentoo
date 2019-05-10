# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils gnome2-utils

DESCRIPTION="Application menu module for GTK"
HOMEPAGE="https://github.com/rilian-la-te/vala-panel-appmenu"
SRC_URI="https://github.com/rilian-la-te/vala-panel-appmenu/releases/download/${PV}/${PN}-module.tar.xz -> ${P}.tar.xz "
S="${WORKDIR}/${PN}-module"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk2"

CDEPEND=""
DEPEND=">=dev-libs/glib-2.50[dbus]
		>=x11-libs/gtk+-3.22.0:3
		gtk2? ( >=x11-libs/gtk+-2.24.0:2 )"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/gtk2-cmake.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DENABLE_GTK2=$(usex gtk2)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}
