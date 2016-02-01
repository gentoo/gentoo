# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MY_VALA_VERSION=0.30
VALA_MIN_API_VERSION=${MY_VALA_VERSION}
VALA_MAX_API_VERSION=${MY_VALA_VERSION}
VALA_USE_DEPEND=vapigen
inherit xfconf vala

DESCRIPTION="Vala bindings for the Xfce desktop environment"
HOMEPAGE="https://wiki.xfce.org/vala-bindings"
SRC_URI="mirror://xfce/src/bindings/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="$(vala_depend)
	>=xfce-base/exo-0.10
	>=xfce-base/garcon-0.2
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfce4-panel-4.10
	>=xfce-base/xfconf-4.10"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README TODO )
	XFCONF=(
		--with-vala-api=${MY_VALA_VERSION}
		)
}

src_prepare() {
	xfconf_src_prepare
	vala_src_prepare
}
