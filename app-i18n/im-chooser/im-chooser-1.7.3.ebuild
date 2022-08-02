# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools xdg

DESCRIPTION="Desktop Input Method configuration tool"
HOMEPAGE="https://pagure.io/im-chooser"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="xfce"

RDEPEND=">=app-i18n/imsettings-1.8
	virtual/libintl
	x11-libs/gtk+:3
	x11-libs/libSM
	xfce? ( xfce-base/libxfce4util )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/autoconf-archive
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "/PKG_CHECK_MODULES/s/\(libxfce4util-1\.0\)/$(usex xfce '\1' _)/" \
		-e "/^GNOME_/d" \
		-e "/^CFLAGS/s/\$WARN_CFLAGS/-Wall -Wmissing-prototypes/" \
		configure.ac
	sed -i "s/Applications;//" src/app/${PN}.desktop.in.in

	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
