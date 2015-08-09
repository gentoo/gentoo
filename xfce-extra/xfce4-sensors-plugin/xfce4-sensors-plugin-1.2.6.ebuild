# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EAUTORECONF=yes
inherit multilib xfconf

DESCRIPTION="A panel plug-in for different sensors using acpi, lm_sensors and hddtemp"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-sensors-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+acpi debug hddtemp libnotify lm_sensors video_cards_nvidia"

REQUIRED_USE="|| ( hddtemp lm_sensors acpi )"

RDEPEND=">=x11-libs/gtk+-2.14:2=
	>=xfce-base/libxfce4ui-4.8:=
	>=xfce-base/xfce4-panel-4.8:=
	hddtemp? ( app-admin/hddtemp net-analyzer/gnu-netcat )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	lm_sensors? ( >=sys-apps/lm_sensors-3.1.0:= )
	video_cards_nvidia? ( media-video/nvidia-settings )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable lm_sensors libsensors)
		$(use_enable hddtemp)
		$(use_enable hddtemp netcat)
		$(use_enable acpi procacpi)
		$(use_enable acpi sysfsacpi)
		$(use_enable video_cards_nvidia xnvctrl)
		$(use_enable libnotify notification)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS NOTES README TODO )
}

src_prepare() {
	sed -i -e '/-no-undefined/d' src/Makefile.am || die

	# Use flags from xfce4-dev-tools instead of defining them again in
	# configure.in wrt #386979
	# Remove AC_PROG_LIBTOOL because LT_INIT([disable-static]) is also present:
	# http://bugzilla.xfce.org/show_bug.cgi?id=8888
	# Use AC_CONFIG_HEADERS for automake-1.13 compability, see:
	# http://bugzilla.xfce.org/show_bug.cgi?id=10031
	sed -i \
		-e '/PLATFORM_CFLAGS/s:-Werror::' \
		configure.ac || die

	xfconf_src_prepare
}
