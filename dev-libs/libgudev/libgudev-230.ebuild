# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2 multilib-minimal

DESCRIPTION="GObject bindings for libudev"
HOMEPAGE="https://wiki.gnome.org/Projects/libgudev"

LICENSE="LGPL-2.1"
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="introspection static-libs"

DEPEND=">=dev-libs/glib-2.22.0:2=[static-libs?]
	virtual/libudev:=[static-libs?]
	introspection? ( dev-libs/gobject-introspection )"
RDEPEND="${DEPEND}
	!sys-fs/eudev[gudev(-)]
	!sys-fs/udev[gudev(-)]
	!sys-apps/systemd[gudev(-)]"

multilib_src_configure() {
	ECONF_SOURCE=${S} gnome2_src_configure \
		$(multilib_native_use_enable introspection) \
		$(use_enable static-libs static)
}

multilib_src_install() {
	gnome2_src_install
}
