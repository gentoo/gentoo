# Copyright 2015-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson-multilib

DESCRIPTION="GObject bindings for libudev"
HOMEPAGE="https://wiki.gnome.org/Projects/libgudev"
SRC_URI="https://download.gnome.org/sources/libgudev/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="introspection static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.38.0:2[${MULTILIB_USEDEP},static-libs?]
	>=virtual/libudev-199:=[${MULTILIB_USEDEP},static-libs(-)?]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
"
DEPEND="${RDEPEND}
	test? ( dev-util/umockdev[${MULTILIB_USEDEP}] )
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

src_prepare() {
	default
	# avoid multilib checksum mismatch
	sed -i -e 's:@filename@:gudev/gudevenums.h:' gudev/gudevenumtypes.h.template || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature introspection)
		-Dgtk_doc=false
		-Ddefault_library=$(usex static-libs both shared)
		$(meson_feature test tests)
		-Dvapi=disabled
	)
	meson_src_configure
}

src_test() {
	# libsandbox interferes somehow.
	# There are no access violations, but tests fail.
	# https://bugs.gentoo.org/805449
	local -x SANDBOX_ON=0
	meson-multilib_src_test
}
