# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/ristretto/ristretto-0.8.0-r1.ebuild,v 1.3 2015/07/01 16:32:36 zlogene Exp $

EAPI=5
inherit xfconf

DESCRIPTION="A fast and lightweight picture viewer for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/applications/ristretto"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="debug"

RDEPEND=">=dev-libs/dbus-glib-0.98:0=
	>=dev-libs/glib-2.24:2=
	media-libs/libexif:0=
	x11-libs/cairo:0=
	>=x11-libs/gtk+-2.20:2=
	x11-libs/libX11:0=
	>=xfce-base/libxfce4ui-4.10:0=
	>=xfce-base/libxfce4util-4.10:0=
	>=xfce-base/xfconf-4.10:0="
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${P}-fix-appdata-validation.patch
		"${FILESDIR}"/${P}-fix-icon-installation.patch
		)

	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS TODO )
}
