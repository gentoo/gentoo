# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-dict/xfce4-dict-0.6.0.ebuild,v 1.14 2012/11/28 12:20:54 ssuominen Exp $

EAPI=5
EAUTORECONF=yes
inherit multilib xfconf

DESCRIPTION="A dict.org querying application and panel plug-in for the Xfce desktop"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfce4-dict"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/glib-2.24
	>=x11-libs/gtk+-2.20:2
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-underlinking.patch )

	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		)

	DOCS=( AUTHORS ChangeLog README )
}

src_prepare() {
	# xfce4-dict.desktop: (will be fatal in the future): value "Dictionary" in key
	# "Categories" in group "Desktop Entry" requires another category to be present
	# among the following categories: Office;TextTools
	sed -i -e '/Categories/s:Office:&;Utility;TextTools:' src/xfce4-dict.desktop.in || die
	xfconf_src_prepare
}
