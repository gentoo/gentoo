# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )
inherit flag-o-matic gnome.org gnome2-utils meson python-any-r1 readme.gentoo-r1 xdg

DESCRIPTION="A terminal emulator for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-terminal"

LICENSE="GPL-3+ GPL-3 CC-BY-SA-3.0 FDL-1.3"

SLOT="0"

KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"

IUSE="X debug gnome-shell nautilus wayland"

# FIXME: automagic dependency on gtk+[X], just transitive but needs proper control, bug 624960
RDEPEND="
	>=dev-libs/glib-2.52:2
	>=x11-libs/gtk+-3.22.27:3[X?,wayland?]
	>=gui-libs/libhandy-1.6.0:1
	>=x11-libs/vte-0.78.0:2.91
	>=dev-libs/libpcre2-10
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/util-linux
	gnome-shell? ( gnome-base/gnome-shell )
	nautilus? ( >=gnome-base/nautilus-43.0 )
"
DEPEND="${RDEPEND}"
# itstool required for help/* with non-en LINGUAS, see bug #549358
# xmllint required for glib-compile-resources, see bug #549304
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DOC_CONTENTS="To get previous working directory inherited in new opened tab, or
	notifications of long-running commands finishing, you will need
	to add the following line to your ~/.bashrc:\n
	. /etc/profile.d/vte-2.91.sh"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-3.44.1-fix-missing-wexitcode.patch
	default
}

src_configure() {
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

	# Upstream don't support LTO & error out on it in meson.build (bug #926156)
	filter-lto

	local emesonargs=(
		$(meson_use debug dbg)
		-Ddocs=false
		$(meson_use nautilus nautilus_extension)
		$(meson_use gnome-shell search_provider)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
