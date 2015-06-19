# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/xfburn/xfburn-0.5.4.ebuild,v 1.1 2015/05/17 15:19:45 mgorny Exp $

EAPI=5
inherit xfconf

DESCRIPTION="GTK+ based CD and DVD burning application"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfburn"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="debug gstreamer +udev"

RDEPEND=">=dev-libs/glib-2.32:=
	>=dev-libs/libburn-0.4.2:=
	>=dev-libs/libisofs-0.6.2:=
	>=x11-libs/gtk+-2.24:2=
	>=xfce-base/exo-0.6:=
	>=xfce-base/libxfce4ui-4.10:=
	gstreamer? (
		media-libs/gstreamer:1.0=
		media-libs/gst-plugins-base:1.0= )
	udev? ( virtual/libgudev:= )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable udev gudev)
		$(use_enable gstreamer)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}
