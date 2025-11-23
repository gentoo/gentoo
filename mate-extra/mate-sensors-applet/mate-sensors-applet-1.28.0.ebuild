# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="MATE panel applet to display readings from hardware sensors"
LICENSE="FDL-1.1+ GPL-2+"
SLOT="0"

IUSE="+dbus hddtemp libnotify lm-sensors video_cards_nvidia"

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	>=mate-base/mate-panel-1.28.0
	>=x11-libs/cairo-1.0.4
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	hddtemp? ( >=app-admin/hddtemp-0.3_beta13 )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	lm-sensors? ( sys-apps/lm-sensors )
	video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-100.14.09:0[static-libs,tools] )
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

BDEPEND="${COMMON_DEPEND}
	app-text/rarian
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PDEPEND="hddtemp? ( dbus? ( sys-fs/udisks:2 ) )"

src_configure() {
	local udisks

	if use hddtemp && use dbus; then
		udisks="--enable-udisks2"
	else
		udisks="--disable-udisks2"
	fi

	mate_src_configure \
		--disable-netbsd \
		$(use_enable libnotify) \
		$(use_with lm-sensors libsensors) \
		$(use_with video_cards_nvidia nvidia) \
		${udisks}
}
