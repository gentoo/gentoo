# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-mixer/xfce4-mixer-4.10.0.ebuild,v 1.9 2012/11/28 12:20:23 ssuominen Exp $

EAPI=5
inherit xfconf

DESCRIPTION="A volume control application (and panel plug-in) for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/xfce4-mixer/"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="alsa debug oss"

COMMON_DEPEND=">=dev-libs/glib-2.24
	dev-libs/libunique:1
	dev-libs/keybinder:0
	media-libs/gst-plugins-base:0.10
	>=x11-libs/gtk+-2.20:2
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfce4-panel-4.10
	>=xfce-base/xfconf-4.10"
RDEPEND="${COMMON_DEPEND}
	alsa? ( media-plugins/gst-plugins-alsa:0.10 )
	oss? ( media-plugins/gst-plugins-oss:0.10 )
	!alsa? ( !oss? ( media-plugins/gst-plugins-meta:0.10 ) )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}
