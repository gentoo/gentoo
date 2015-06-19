# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-linelight-plugin/xfce4-linelight-plugin-0.1.7.ebuild,v 1.7 2012/11/28 12:24:41 ssuominen Exp $

EAPI=5
EAUTORECONF=yes
inherit multilib xfconf

DESCRIPTION="A simple locate based search plug-in for the Xfce panel"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-linelight-plugin"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.bz2"
#SRC_URI="http://svn.ganymede.ch/private/trunk/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.12:2
	>=xfce-base/xfce4-panel-4.8
	>=xfce-base/libxfcegui4-4.8"
RDEPEND="${COMMON_DEPEND}
	sys-apps/mlocate"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${P}-port-to-xfcerc.patch
		)

	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		)

	DOCS=( AUTHORS ChangeLog NEWS )
}
