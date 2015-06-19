# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-mailwatch-plugin/xfce4-mailwatch-plugin-1.2.0.ebuild,v 1.5 2014/03/01 22:28:38 mgorny Exp $

EAPI=5
inherit xfconf

DESCRIPTION="An mail notification panel plug-in for the Xfce desktop environment"
HOMEPAGE="http://spuriousinterrupt.org/projects/xfce4-mailwatch-plugin/"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug ipv6 ssl"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.18:2
	x11-libs/libX11
	>=xfce-base/exo-0.7.2
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfce4-panel-4.10
	ssl? (
		dev-libs/libgcrypt:0
		>=net-libs/gnutls-2
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable ssl)
		$(use_enable ipv6)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}
