# Copyright 2015-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson-multilib

DESCRIPTION="GObject bindings for libudev"
HOMEPAGE="https://wiki.gnome.org/Projects/libgudev"
SRC_URI="https://download.gnome.org/sources/libgudev/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="introspection static-libs"

DEPEND="
	>=dev-libs/glib-2.38.0:2[${MULTILIB_USEDEP},static-libs?]
	>=virtual/libudev-199:=[${MULTILIB_USEDEP},static-libs(-)?]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
"
RDEPEND="${DEPEND}
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
		-Dtests=disabled # umockdev tests currently don't pass (might need extra setup)
		-Dvapi=disabled
	)
	meson_src_configure
}
