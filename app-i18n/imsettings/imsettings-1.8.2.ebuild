# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

DESCRIPTION="Delivery framework for general Input Method configuration"
HOMEPAGE="https://tagoh.bitbucket.io/imsettings"
SRC_URI="https://bitbucket.org/tagoh/${PN}/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="gconf qt5 +introspection xfconf"
RESTRICT="test"

RDEPEND="dev-libs/glib:2
	sys-apps/dbus
	virtual/libintl
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libgxim
	x11-libs/libnotify
	gconf? ( gnome-base/gconf )
	introspection? ( dev-libs/gobject-introspection )
	xfconf? ( xfce-base/xfconf )"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils
	sys-devel/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-fno-common.patch )

MY_XINPUTSH="90-xinput"

src_prepare() {
	sed -i \
		-e "/PKG_CHECK_MODULES/s/\(gconf-2\.0\)/$(usex gconf '\1' _)/" \
		-e "/PKG_CHECK_MODULES/s/\(gtk+-2\.0\)/_/" \
		-e "/PKG_CHECK_MODULES/s/\(check\)/_/" \
		-e "/PKG_CHECK_MODULES/s/\(libxfconf-0\)/$(usex xfconf '\1' _)/" \
		-e "s/use_qt=\"yes\"/use_qt=\"$(usex qt5)\"/" \
		-e "/^GNOME_/d" \
		-e "/^CFLAGS/s/\$WARN_CFLAGS/-Wall -Wmissing-prototypes/" \
		configure.ac

	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-xinputsh=${MY_XINPUTSH}
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	fperms 0755 /etc/X11/xinit/xinitrc.d/${MY_XINPUTSH}
}

pkg_postinst() {
	if [[ ! -e "${EPREFIX}"/etc/X11/xinit/xinputrc ]]; then
		ln -sf xinput.d/xcompose.conf "${EPREFIX}"/etc/X11/xinit/xinputrc
	fi
}
