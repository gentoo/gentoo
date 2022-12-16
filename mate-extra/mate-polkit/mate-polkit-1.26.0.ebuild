# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="A MATE specific DBUS service that is used to bring up authentication dialogs"
LICENSE="LGPL-2"
SLOT="0"

IUSE="accountsservice appindicator"

COMMON_DEPEND="x11-libs/gdk-pixbuf:2
	virtual/libintl:0
	>=x11-libs/gtk+-3.22.0:3
	appindicator? ( dev-libs/libappindicator:3 )"

RDEPEND="${COMMON_DEPEND}
	>=dev-libs/glib-2.50:2
	>=sys-auth/polkit-0.102
	accountsservice? ( sys-apps/accountsservice )"

BDEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	sys-devel/gettext
	>=sys-devel/libtool-2.2.6
	virtual/pkgconfig"

src_configure() {
	mate_src_configure \
		--disable-static \
		$(use_enable accountsservice) \
		$(use_enable appindicator)
}
