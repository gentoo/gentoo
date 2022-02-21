# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
VALA_USE_DEPEND=vapigen

inherit bash-completion-r1 gnome2 meson-multilib python-any-r1 vala virtualx

DESCRIPTION="GObject library for accessing the freedesktop.org Secret Service API"
HOMEPAGE="https://wiki.gnome.org/Projects/Libsecret"

LICENSE="LGPL-2.1+ Apache-2.0" # Apache-2.0 license is used for tests only
SLOT="0"

IUSE="+crypt gtk-doc +introspection test tpm +vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	vala? ( introspection )
	gtk-doc? ( crypt )
"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="
	>=dev-libs/glib-2.44:2[${MULTILIB_USEDEP}]
	crypt? ( >=dev-libs/libgcrypt-1.2.2:0=[${MULTILIB_USEDEP}] )
	tpm? ( >=app-crypt/tpm2-tss-3.0.3 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}
	virtual/secret-service"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gi-docgen-2021.7
	)
	test? (
		$(python_gen_any_dep '
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
			introspection? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )')
		introspection? ( >=dev-libs/gjs-1.32 )
	)
	vala? ( $(vala_depend) )
"

python_check_deps() {
	if use introspection; then
		has_version -b "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
	fi
	has_version -b "dev-python/mock[${PYTHON_USEDEP}]" &&
	has_version -b "dev-python/dbus-python[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	default
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_true manpage)
		$(meson_use crypt gcrypt)
		$(meson_native_use_bool vala vapi)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_bool introspection)
		-Dbashcompdir="$(get_bashcompdir)"
		$(meson_native_enabled bash_completion)
		$(meson_native_use_bool tpm tpm2)
	)
	meson_src_configure
}

multilib_src_test() {
	virtx meson_src_test
}
