# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2-utils systemd

DESCRIPTION="Application menu module for GTK"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/570a2d1a65e77d42cb19e5972d0d1b84/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
IUSE="wayland"

RDEPEND="
	dev-libs/glib[dbus]
	>=x11-libs/gtk+-2.24.0:2
	>=x11-libs/gtk+-3.22.0:3[wayland=]
"
DEPEND="${RDEPEND}
	dev-libs/wayland
"

src_prepare() {
	cmake_src_prepare
	sed -i -e "/^pkg_check_modules(SYSTEMD/d" data/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_VCM=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}"/${PN} 85-${PN}

	systemd_dounit "${BUILD_DIR}"/data/appmenu-gtk-module.service
}

pkg_postinst() {
	gnome2_schemas_update
}
