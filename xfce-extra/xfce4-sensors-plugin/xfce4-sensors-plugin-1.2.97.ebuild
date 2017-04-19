# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A panel plug-in for acpi, lm_sensors and hddtemp sensors"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-sensors-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+acpi hddtemp libnotify lm_sensors video_cards_nvidia"

REQUIRED_USE="|| ( hddtemp lm_sensors acpi )"

RDEPEND=">=x11-libs/gtk+-3.20:3=
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.12:=
	hddtemp? ( app-admin/hddtemp net-analyzer/gnu-netcat )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	lm_sensors? ( >=sys-apps/lm_sensors-3.1.0:= )
	video_cards_nvidia? (
		|| (
			x11-drivers/nvidia-drivers[tools,static-libs]
			media-video/nvidia-settings
			)
	)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS NOTES README TODO )

src_configure() {
	local myconf=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable lm_sensors libsensors)
		$(use_enable hddtemp)
		$(use_enable hddtemp netcat)
		$(use_enable acpi procacpi)
		$(use_enable acpi sysfsacpi)
		$(use_enable video_cards_nvidia xnvctrl)
		$(use_enable libnotify notification)
	)

	econf "${myconf[@]}"
}
