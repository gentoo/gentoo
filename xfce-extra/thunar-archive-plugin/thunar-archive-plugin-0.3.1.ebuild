# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/thunar-archive-plugin/thunar-archive-plugin-0.3.1.ebuild,v 1.9 2014/04/19 17:46:17 ago Exp $

EAPI=5
inherit xfconf

DESCRIPTION="Archive plug-in for the Thunar filemanager"
HOMEPAGE="http://goodies.xfce.org/projects/thunar-plugins/thunar-archive-plugin"
SRC_URI="mirror://xfce/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=xfce-base/libxfce4util-4.8
	>=xfce-base/exo-0.6
	>=xfce-base/thunar-1.2"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=( $(xfconf_use_debug) )
	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
