# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python3_{4,5,6} )
VALA_USE_DEPEND=vapigen

inherit gnome2 python-any-r1 vala virtualx

DESCRIPTION="GObject library for accessing the freedesktop.org Secret Service API"
HOMEPAGE="https://wiki.gnome.org/Projects/Libsecret"

LICENSE="LGPL-2.1+ Apache-2.0" # Apache-2.0 license is used for tests only
SLOT="0"

IUSE="+crypt +introspection test vala"
# Tests fail with USE=-introspection, https://bugs.gentoo.org/655482
REQUIRED_USE="test? ( introspection )
	vala? ( introspection )"

KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ~ppc ppc64 ~sparc x86 ~amd64-fbsd"

RDEPEND="
	>=dev-libs/glib-2.38:2
	crypt? ( >=dev-libs/libgcrypt-1.2.2:0= )
	introspection? ( >=dev-libs/gobject-introspection-1.29:= )
"
PDEPEND=">=gnome-base/gnome-keyring-3
"
# PDEPEND to avoid circular dep (bug #547456)
# gnome-keyring needed at runtime as explained at https://bugs.gentoo.org/475182#c2
# Add ksecrets to PDEPEND when it's added to portage
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
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
		has_version --host-root "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
	fi
	has_version --host-root "dev-python/mock[${PYTHON_USEDEP}]" &&
	has_version --host-root "dev-python/dbus-python[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-manpages \
		--disable-strict \
		--disable-coverage \
		--disable-static \
		$(use_enable crypt gcrypt) \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_test() {
	Xemake check
}
