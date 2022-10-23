# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson-multilib xdg-utils

DESCRIPTION="A library for sending desktop notifications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libnotify"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="gtk-doc +introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.38:2[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-libs/gobject-introspection-common-1.32
	dev-util/glib-utils
	virtual/pkgconfig
	app-text/docbook-xsl-ns-stylesheets
	dev-libs/libxslt
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2 )
	test? ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
"
IDEPEND="app-eselect/eselect-notify-send"
PDEPEND="virtual/notification-daemon"

src_prepare() {
	default
	xdg_environment_reset
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		$(meson_native_use_feature introspection)
		$(meson_native_use_bool gtk-doc gtk_doc)
		-Ddocbook_docs=disabled
	)
	meson_src_configure
}

multilib_src_install() {
	meson_src_install

	mv "${ED}"/usr/bin/{,libnotify-}notify-send || die #379941
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}
