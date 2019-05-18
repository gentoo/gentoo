# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-volman"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~ia64 ppc ppc64 ~sparc x86"
IUSE="libnotify"

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

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_configure() {
	local myconf=(
		$(use_enable libnotify notifications)
		)
	econf "${myconf[@]}"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
