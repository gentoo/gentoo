# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-volman"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

# CC for tvm-burn-cd.svg
LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="libnotify"

DEPEND=">=dev-libs/glib-2.50
	dev-libs/libgudev:=
	>=x11-libs/gtk+-3.20:3
	>=xfce-base/exo-0.10:=
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfconf-4.12:=
	libnotify? ( >=x11-libs/libnotify-0.7 )"
RDEPEND="${DEPEND}
	virtual/udev
	>=xfce-base/thunar-1.6[udisks]"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable libnotify notifications)
	)
	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
