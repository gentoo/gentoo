# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-cpufreq-plugin/xfce4-cpufreq-plugin-1.1.2.ebuild,v 1.3 2015/07/01 16:49:49 zlogene Exp $

EAPI=5
inherit xfconf

DESCRIPTION="A panel plugin for showing information about cpufreq settings"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-cpufreq-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.20:=
	>=x11-libs/gtk+-2.14:2=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/xfce4-panel-4.10:="
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}
