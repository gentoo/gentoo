# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
VALA_USE_DEPEND=vapigen

inherit gnome2 meson multilib-minimal python-any-r1 vala virtualx

DESCRIPTION="GObject library for accessing the freedesktop.org Secret Service API"
HOMEPAGE="https://wiki.gnome.org/Projects/Libsecret"

LICENSE="LGPL-2.1+ Apache-2.0" # Apache-2.0 license is used for tests only
SLOT="0"

IUSE="+crypt gtk-doc +introspection test +vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND="
	>=dev-libs/glib-2.44:2[${MULTILIB_USEDEP}]
	crypt? ( >=dev-libs/libgcrypt-1.2.2:0=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.29:= )
"
RDEPEND="${DEPEND}"
# gnome-keyring needed at runtime as explained at https://bugs.gentoo.org/475182#c2
PDEPEND=">=gnome-base/gnome-keyring-3" # to avoid circular dep (bug #547456)
BDEPEND="
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
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

PATCHES=(
	"${FILESDIR}"/${P}-meson-build-test-vala-unstable-with-DSECRET_WITH_UNS.patch
)

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

	# Remove @filename@ from the header template that would otherwise cause
	# differences dependent on the ABI
	sed -e '/enumerations from "@filename@"/d' \
		-i libsecret/secret-enum-types.h.template || die
}

meson_multilib_native_use() {
	multilib_native_usex "$1" "-D${2-$1}=true" "-D${2-$1}=false"
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use crypt gcrypt)

		# Don't build docs multiple times
		-Dmanpage=$(multilib_is_native_abi && echo true || echo false)
		$(meson_multilib_native_use gtk-doc gtk_doc)

		$(meson_multilib_native_use introspection)
		$(meson_multilib_native_use vala vapi)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	virtx meson_src_test
}

multilib_src_install() {
	meson_src_install
}
