# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="
	https://docs.xfce.org/xfce/thunar/thunar-volman
	https://gitlab.xfce.org/xfce/thunar-volman/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

# CC for tvm-burn-cd.svg
LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="libnotify"

DEPEND="
	>=dev-libs/glib-2.72.0
	dev-libs/libgudev:=
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/exo-0.10.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.12.0:=
	>=xfce-base/xfconf-4.12.0:=
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
"
RDEPEND="
	${DEPEND}
	virtual/udev
	>=xfce-base/thunar-1.6[udisks]
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

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
