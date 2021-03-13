# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 multilib-minimal

DESCRIPTION="GObject bindings for libudev"
HOMEPAGE="https://wiki.gnome.org/Projects/libgudev"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="introspection static-libs"

DEPEND="
	>=dev-libs/glib-2.38.0:2[${MULTILIB_USEDEP},static-libs?]
	>=virtual/libudev-199:=[${MULTILIB_USEDEP},static-libs(-)?]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
"
RDEPEND="${DEPEND}
	!sys-fs/eudev[gudev(-)]
	!sys-fs/udev[gudev(-)]
	!sys-apps/systemd[gudev(-)]
"
BDEPEND="
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.18
	virtual/pkgconfig
"

multilib_src_configure() {
	local myconf=(
		$(multilib_native_use_enable introspection)
		$(use_enable static-libs static)
		--disable-umockdev # umockdev tests currently don't pass (might need extra setup)
	)
	local ECONF_SOURCE="${S}"
	gnome2_src_configure "${myconf[@]}"
}

multilib_src_install() {
	gnome2_src_install
}
