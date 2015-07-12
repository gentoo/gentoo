# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-smartbookmark-plugin/xfce4-smartbookmark-plugin-0.4.6.ebuild,v 1.6 2015/07/12 09:32:29 jer Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Smart bookmark plug-in for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-smartbookmark-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug"

COMMON_DEPEND="x11-libs/gtk+:2=
	x11-libs/libX11:=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/xfce4-panel-4.10:="
RDEPEND="${COMMON_DEPEND}
	>=xfce-base/exo-0.8"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}
src_prepare() {
	sed -i -e '/bugs/s:debian:gentoo:' src/smartbookmark.c || die
	xfconf_src_prepare
}
