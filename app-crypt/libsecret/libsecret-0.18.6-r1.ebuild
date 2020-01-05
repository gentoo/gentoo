# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )
VALA_USE_DEPEND=vapigen

inherit gnome2 multilib-minimal python-any-r1 vala virtualx

DESCRIPTION="GObject library for accessing the freedesktop.org Secret Service API"
HOMEPAGE="https://wiki.gnome.org/Projects/Libsecret"

LICENSE="LGPL-2.1+ Apache-2.0" # Apache-2.0 license is used for tests only
SLOT="0"

IUSE="+crypt +introspection test vala"
RESTRICT="!test? ( test )"
# Tests fail with USE=-introspection, https://bugs.gentoo.org/655482
REQUIRED_USE="test? ( introspection )
	vala? ( introspection )"

KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 sparc x86"

RDEPEND="
	>=dev-libs/glib-2.38:2[${MULTILIB_USEDEP}]
	crypt? ( >=dev-libs/libgcrypt-1.2.2:0=[${MULTILIB_USEDEP}] )
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
	virtual/pkgconfig[${MULTILIB_USEDEP}]
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

	# Drop unwanted CFLAGS modifications
	sed -e 's/CFLAGS="$CFLAGS -\(g\|O0\|O2\)"//' -i configure || die
}

multilib_src_configure() {
	local ECONF_SOURCE=${S}
	gnome2_src_configure \
		--enable-manpages \
		--disable-strict \
		--disable-coverage \
		--disable-static \
		$(use_enable crypt gcrypt) \
		$(multilib_native_use_enable introspection) \
		$(multilib_native_use_enable vala) \
		LIBGCRYPT_CONFIG="${EPREFIX}/usr/bin/${CHOST}-libgcrypt-config"

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/reference/libsecret/html docs/reference/libsecret/html || die
	fi
}

multilib_src_test() {
	# tests fail without gobject-introspection
	multilib_is_native_abi && virtx emake check
}

multilib_src_install() {
	gnome2_src_install
}
