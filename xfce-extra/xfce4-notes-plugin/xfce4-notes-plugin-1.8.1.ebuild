# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-notes-plugin/xfce4-notes-plugin-1.8.1.ebuild,v 1.5 2015/07/11 07:08:58 maekke Exp $

EAPI=5
inherit versionator xfconf

DESCRIPTION="Xfce4 panel sticky notes plugin"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-notes-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/glib-2.24:2=
	>=x11-libs/gtk+-2.20:2=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/xfce4-panel-4.10:=
	>=xfce-base/xfconf-4.10:=
	dev-libs/libunique:1="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README )
}
