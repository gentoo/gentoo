# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION=0.42
VALA_MAX_API_VERSION=${VALA_MIN_API_VERSION}
VALA_USE_DEPEND=vapigen
inherit vala

DESCRIPTION="Vala bindings for the Xfce desktop environment"
HOMEPAGE="https://wiki.xfce.org/vala-bindings"
SRC_URI="https://archive.xfce.org/src/bindings/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="$(vala_depend)
	>=xfce-base/exo-0.10:=
	>=xfce-base/garcon-0.2:=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/xfce4-panel-4.10:=
	>=xfce-base/xfconf-4.10:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
}

src_configure() {
	local myconf=(
		"--with-vala-api=${VALA_MIN_API_VERSION}"
	)

	vala_src_prepare
	econf "${myconf[@]}"
}
