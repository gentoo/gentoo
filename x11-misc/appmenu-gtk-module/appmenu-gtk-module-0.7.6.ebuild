# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson multilib-minimal multilib-build systemd

DESCRIPTION="Application menu module for GTK"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/e0b6a32a340922cd05060292b0757162/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib[dbus,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.0:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.22.0:3[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${PN}"

multilib_src_configure() {
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
	if multilib_is_native_abi; then
		exeinto /etc/X11/xinit/xinitrc.d
		newexe "${FILESDIR}"/${PN} 85-${PN}
		systemd_douserunit "${BUILD_DIR}"/data/appmenu-gtk-module.service
	fi
}

pkg_postinst() {
	gnome2_schemas_update
	elog "To enable global menu support for GTK+ applications, run:"
	elog "'systemctl --user enable appmenu-gtk-module --now'"
	elog ""
}
