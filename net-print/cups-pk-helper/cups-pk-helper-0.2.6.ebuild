# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="PolicyKit helper to configure cups with fine-grained privileges"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/cups-pk-helper"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=dev-libs/glib-2.30.0:2
	net-print/cups
	>=sys-auth/polkit-0.97
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/dbus
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gdbus-codegen-2.30.0
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	sys-devel/gettext
"

src_prepare() {
	DOCS="AUTHORS HACKING NEWS README"

	# Regenerate dbus-codegen files to fix build with glib-2.30.x; bug #410773
	rm -v src/cph-iface-mechanism.{c,h} || die

	gnome2_src_prepare
}
