# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgudev/libgudev-230.ebuild,v 1.6 2015/07/10 13:35:32 floppym Exp $

EAPI=5

inherit gnome2 multilib-minimal

DESCRIPTION="GObject bindings for libudev"
HOMEPAGE="https://wiki.gnome.org/Projects/libgudev"
SRC_URI="https://download.gnome.org/sources/libgudev/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc introspection static-libs"

DEPEND=">=dev-libs/glib-2.22.0:2=[static-libs?]
	virtual/libudev:=[static-libs?]"
RDEPEND="${DEPEND}
	!sys-fs/eudev[gudev(-)]
	!sys-fs/udev[gudev(-)]
	!sys-apps/systemd[gudev(-)]"

multilib_src_configure() {
	local G2CONF="
		$(multilib_native_use_enable introspection)
		$(use_enable static-libs static)
	"
	ECONF_SOURCE=${S} gnome2_src_configure
}

multilib_src_install() {
	gnome2_src_install
}
