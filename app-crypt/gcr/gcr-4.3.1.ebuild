# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"

LICENSE="GPL-2+ LGPL-2+"
SLOT="4/gcr-4.4-gck-2.2" # subslot = soname and soversion of libgcr and libgck

KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~mips ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

IUSE="gnutls gtk gtk-doc +introspection systemd test +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.68.0:2
	!gnutls? ( >=dev-libs/libgcrypt-1.2.2:0= )
	gnutls? ( >=net-libs/gnutls-3.8.5:0 )
	>=app-crypt/p11-kit-0.19.0
	>=app-crypt/libsecret-0.20
	systemd? ( sys-apps/systemd:= )
	gtk? ( gui-libs/gtk:4[introspection?] )
	>=sys-apps/dbus-1
	introspection? ( >=dev-libs/gobject-introspection-1.58:= )
"
RDEPEND="${DEPEND}"
PDEPEND="app-crypt/gnupg"
BDEPEND="
	gtk? ( dev-libs/libxml2:2 )
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? ( dev-util/gi-docgen )
	>=sys-devel/gettext-0.19.8
	test? ( app-crypt/gnupg )
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	filter-lto # https://gitlab.gnome.org/GNOME/gcr/-/issues/43
	local emesonargs=(
		$(meson_use introspection)
		$(meson_use gtk gtk4)
		$(meson_use gtk-doc gtk_doc)
		-Dgpg_path="${EPREFIX}"/usr/bin/gpg
		-Dssh_agent=true
		$(meson_feature systemd)
		$(meson_use vala vapi)
	)
	if use gnutls; then
		emesonargs+=( -Dcrypto=gnutls )
	else
		emesonargs+=( -Dcrypto=libgcrypt )
	fi
	meson_src_configure
}

src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/{gck-2,gcr-4} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
