# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools ltprune

DESCRIPTION="Desktop Input Method configuration tool"
HOMEPAGE="https://pagure.io/im-chooser"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="gtk2 xfce"

RDEPEND="app-i18n/imsettings
	virtual/libintl
	x11-libs/libSM
	gtk2? ( x11-libs/gtk+:2 )
	!gtk2? ( x11-libs/gtk+:3 )
	xfce? ( xfce-base/libxfce4util )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "/PKG_CHECK_MODULES/s/\(gtk+-3\.0\)/$(usex !gtk2 '\1' _)/" \
		-e "/PKG_CHECK_MODULES/s/\(libxfce4util-1\.0\)/$(usex xfce '\1' _)/" \
		-e "/^GNOME_/d" \
		-e "/^CFLAGS/s/\$WARN_CFLAGS/-Wall -Wmissing-prototypes/" \
		configure.ac

	default
	eautoreconf
}

src_install() {
	default
	prune_libtool_files
}
