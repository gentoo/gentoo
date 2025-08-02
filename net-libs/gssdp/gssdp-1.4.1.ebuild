# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson-multilib vala xdg

DESCRIPTION="GObject-based API for handling resource discovery and announcement over SSDP"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP https://gitlab.gnome.org/GNOME/gssdp"

LICENSE="LGPL-2+"
SLOT="0/1.2-0" # <API version>-<soname>
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection gtk vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.54:2[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.26.1:2.4[${MULTILIB_USEDEP},introspection?]
	gtk? ( gui-libs/gtk:4 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? (
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.1.2
	)
	virtual/pkgconfig
	vala? (
		$(vala_depend)
		net-libs/libsoup:2.4[vala]
	)
"
PATCHES=(
	"${FILESDIR}"/${P}-client-crash.patch
)

src_prepare() {
	default
	use vala && vala_setup
}

multilib_src_configure() {
	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback

		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_bool gtk sniffer)
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool vala vapi)
		-Dexamples=false
	)
	meson_src_configure
}

multilib_src_install_all() {
	if use gtk-doc ; then
		mv "${ED}"/usr/share/doc/{gssdp-1.2,${PF}} || die
		mv "${ED}"/usr/share/doc/${PF}/{reference,html} || die
		rmdir "${ED}"/usr/share/doc/gssdp-1.2
	fi

	# has file collision with slot 1.6 (/usr/bin/gssdp-device-sniffer),
	# so we rename it in this build
	if use gtk; then
		mv "${ED}"/usr/bin/gssdp-device-sniffer \
		   "${ED}"/usr/bin/gssdp-device-sniffer-1.4 || die
	fi
}
