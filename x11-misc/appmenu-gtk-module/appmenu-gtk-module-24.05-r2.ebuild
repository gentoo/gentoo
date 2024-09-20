# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo gnome2-utils flag-o-matic meson systemd virtualx

DESCRIPTION="Application menu module for GTK"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/b5ace7bf5bd6e3ec3b20e98befb5da39/${P}.tar.xz"
# 24.05 really is a different release to 24.02 (diffed tarballs to check),
# but it has the wrong version in the directory name.
S="${WORKDIR}"/${PN}-24.02

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="gtk2 test wayland"
# Tests are manual and hang in the ebuild
RESTRICT="!test? ( test ) test"

RDEPEND="
	dev-libs/glib[dbus]
	>=x11-libs/gtk+-3.22.0:3[wayland?]
	gtk2? ( >=x11-libs/gtk+-2.24.0:2 )
"
DEPEND="
	${RDEPEND}
	wayland? ( dev-libs/wayland )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.7.6-no-automagic-gtk.patch"
	"${FILESDIR}/${PN}-24.05-no-automagic-unitdir.patch"
	"${FILESDIR}/${PN}-24.05-fix-pkgconfig.patch"
)

src_configure() {
	# defang automagic dependencies, bug #785619
	use wayland || append-cflags -DGENTOO_GTK_HIDE_WAYLAND

	# outputs [ '2', '3' ] OR [ '3' ]
	local gtks="[$(usex gtk2 " '2'," '') '3' ]"

	local emesonargs=(
		-Dgtk="${gtks}"
		-Duserunitdir="$(systemd_get_userunitdir)"
		$(meson_use test tests)
	)

	meson_src_configure
}

my_test() {
	cd "${BUILD_DIR}"/tests || die

	local name
	for name in hello radio tester ; do
		edo ./${name}
	done
}

src_test() {
	virtx my_test
}

src_install() {
	meson_src_install

	mv "${ED}"/usr/share/doc/appmenu-gtk-module/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/appmenu-gtk-module || die

	rm "${ED}"/usr/share/licenses/appmenu-gtk-module/LICENSE || die

	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}"/${PN}-r1 85-${PN}
}

pkg_postinst() {
	gnome2_schemas_update
}
