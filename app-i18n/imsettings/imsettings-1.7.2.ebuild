# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools xdg-utils

DESCRIPTION="Delivery framework for general Input Method configuration"
HOMEPAGE="https://tagoh.bitbucket.io/imsettings"
SRC_URI="https://bitbucket.org/tagoh/${PN}/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="gconf gtk2 qt5 +introspection static-libs xfconf"
RESTRICT="test"

RDEPEND="dev-libs/glib:2
	sys-apps/dbus
	virtual/libintl
	x11-libs/libX11
	x11-libs/libgxim
	x11-libs/libnotify
	gconf? ( gnome-base/gconf )
	gtk2? ( x11-libs/gtk+:2 )
	!gtk2? ( x11-libs/gtk+:3 )
	introspection? ( dev-libs/gobject-introspection )
	xfconf? ( xfce-base/xfconf )"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig"

MY_XINPUTSH="90-xinput"

src_prepare() {
	sed -i \
		-e "/PKG_CHECK_MODULES/s/\(gconf-2\.0\)/$(usex gconf '\1' _)/" \
		-e "/PKG_CHECK_MODULES/s/\(gtk+-2\.0\)/$(usex gtk2 '\1' _)/" \
		-e "/PKG_CHECK_MODULES/s/\(gtk+-3\.0\)/$(usex !gtk2 '\1' _)/" \
		-e "/PKG_CHECK_MODULES/s/\(check\)/_/" \
		-e "/PKG_CHECK_MODULES/s/\(libxfconf-0\)/$(usex xfconf '\1' _)/" \
		-e "s/use_qt=\"yes\"/use_qt=\"$(usex qt5)\"/" \
		-e "/^GNOME_/d" \
		-e "/^CFLAGS/s/\$WARN_CFLAGS/-Wall -Wmissing-prototypes/" \
		configure.ac

	default
	eautoreconf
	xdg_environment_reset
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-xinputsh=${MY_XINPUTSH}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	fperms 0755 /etc/X11/xinit/xinitrc.d/${MY_XINPUTSH}
}

pkg_postinst() {
	if [[ ! -e "${EPREFIX}"/etc/X11/xinit/xinputrc ]]; then
		ln -sf xinput.d/xcompose.conf "${EPREFIX}"/etc/X11/xinit/xinputrc
	fi
}
