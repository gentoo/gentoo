# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson systemd

DESCRIPTION="Application menu module for GTK"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/e0b6a32a340922cd05060292b0757162/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="gtk2 wayland"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	dev-libs/glib[dbus]
	>=x11-libs/gtk+-3.22.0:3[wayland=]
	gtk2? ( >=x11-libs/gtk+-2.24.0:2 )
"

DEPEND="${RDEPEND}
	wayland? ( dev-libs/wayland )
"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/0.7.6-no-automagic-gtk.patch"
	"${FILESDIR}/0.7.6-no-automagic-unitdir.patch"
)

src_configure() {
	# outputs [ '2', '3' ] OR [ '3' ]
	local gtks="[$(usex gtk2 " '2'," '') '3' ]"

	meson_src_configure -Dgtk="${gtks}" -Duserunitdir="$(systemd_get_userunitdir)"
}

src_install() {
	meson_src_install

	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}"/${PN} 85-${PN}
}

pkg_postinst() {
	gnome2_schemas_update
}
