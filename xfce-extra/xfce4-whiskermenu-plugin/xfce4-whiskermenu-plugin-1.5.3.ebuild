# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Alternate application launcher for Xfce"
HOMEPAGE="https://gottcode.org/xfce4-whiskermenu-plugin"
SRC_URI="https://github.com/gottcode/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	virtual/libintl:=
	x11-libs/gtk+:2=
	xfce-base/exo:=
	xfce-base/garcon:=
	xfce-base/libxfce4ui:=
	xfce-base/libxfce4util:=
	xfce-base/xfce4-panel:="

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	local i
	cd po || die
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in *.po ; do
			einfo "removing ${i%.po} linguas"
			has ${i%.po} ${LINGUAS} || { rm ${i} || die ; }
		done
	fi

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_AS_NEEDED=OFF
		-DENABLE_LINKER_OPTIMIZED_HASH_TABLES=OFF
		-DENABLE_DEVELOPER_MODE=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc NEWS README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
