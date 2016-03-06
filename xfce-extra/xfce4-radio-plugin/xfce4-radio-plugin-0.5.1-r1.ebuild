# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic multilib xfconf

DESCRIPTION="V4L radio device control plug-in for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-radio-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

RDEPEND=">=xfce-base/libxfcegui4-4.8:=
	>=xfce-base/xfce4-panel-4.8:="
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(xfconf_use_debug)
	)

	DOCS=( AUTHORS NEWS README )

	# fix underlinking, bug #555056
	append-libs -lm
}
