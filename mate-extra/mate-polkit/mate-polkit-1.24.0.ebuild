# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="A MATE specific DBUS service that is used to bring up authentication dialogs"
LICENSE="LGPL-2+"
SLOT="0"

IUSE="accountsservice appindicator"

COMMON_DEPEND=">=dev-libs/glib-2.50:2
	>=sys-auth/polkit-0.102
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22.0:3
	appindicator? ( dev-libs/libappindicator:3 )"

RDEPEND="${COMMON_DEPEND}
	accountsservice? ( sys-apps/accountsservice )
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.8:*
	>=sys-devel/libtool-2.2.6
	virtual/pkgconfig:*
	!<gnome-extra/polkit-gnome-0.102:0"

src_configure() {
	mate_src_configure \
		--disable-static \
		$(use_enable accountsservice) \
		$(use_enable appindicator)
}
