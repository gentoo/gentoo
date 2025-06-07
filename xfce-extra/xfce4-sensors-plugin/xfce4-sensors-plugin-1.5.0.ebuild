# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A panel plug-in for acpi, lm-sensors and hddtemp sensors"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-sensors-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-sensors-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv x86"
IUSE="+acpi hddtemp libnotify lm-sensors video_cards_nvidia"
REQUIRED_USE="|| ( hddtemp lm-sensors acpi )"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.17.2:=
	>=xfce-base/xfce4-panel-4.16.0:=
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	lm-sensors? ( >=sys-apps/lm-sensors-3.1.0:= )
	video_cards_nvidia? (
		x11-libs/libX11
		x11-libs/libXext
		x11-drivers/nvidia-drivers[tools,static-libs]
	)
"
RDEPEND="
	${DEPEND}
	hddtemp? (
		app-admin/hddtemp
		|| (
			net-analyzer/openbsd-netcat
			net-analyzer/netcat
		)
	)
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature libnotify)
		$(meson_feature lm-sensors libsensors)
		$(meson_feature hddtemp)
		-Dhddtemp-path="${EPREFIX}/usr/sbin/hddtemp"
		$(meson_feature hddtemp netcat)
		-Dnetcat-path="${EPREFIX}/usr/bin/nc"
		-Dprocacpi=enabled
		-Dsysfsacpi=enabled
		$(meson_feature video_cards_nvidia xnvctrl)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
