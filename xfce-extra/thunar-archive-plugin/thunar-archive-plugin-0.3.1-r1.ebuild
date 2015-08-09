# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EAUTORECONF="yes"
inherit xfconf

DESCRIPTION="Archive plug-in for the Thunar filemanager"
HOMEPAGE="http://goodies.xfce.org/projects/thunar-plugins/thunar-archive-plugin"
SRC_URI="mirror://xfce/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=xfce-base/libxfce4util-4.8:=
	>=xfce-base/exo-0.6:=
	>=xfce-base/thunar-1.2:="
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/0.3.1-add-engrampa-support.patch "${FILESDIR}"/0.3.1-fix-file-roller.patch )
	XFCONF=( $(xfconf_use_debug) )
	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
