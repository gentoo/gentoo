# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xfconf

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-volman"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ppc ppc64 sparc x86"
IUSE="debug libnotify"

COMMON_DEPEND=">=dev-libs/glib-2.30
	virtual/libgudev:=
	>=x11-libs/gtk+-2.24:2
	>=xfce-base/exo-0.10
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfconf-4.10
	libnotify? ( >=x11-libs/libnotify-0.7 )"
RDEPEND="${COMMON_DEPEND}
	virtual/udev
	>=xfce-base/thunar-1.6[udisks]"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable libnotify notifications)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
