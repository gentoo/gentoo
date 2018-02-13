# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils

DESCRIPTION="Archive plug-in for the Thunar filemanager"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-archive-plugin"
SRC_URI="mirror://xfce/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=xfce-base/libxfce4util-4.8:=
	>=xfce-base/exo-0.6:=
	>=xfce-base/thunar-1.2:="
# dev-util/xfce4-dev-tools for eautoreconf
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/xfce4-dev-tools
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/0.3.1-add-engrampa-support.patch
	"${FILESDIR}"/0.3.1-fix-kde-ark.patch
	"${FILESDIR}"/0.3.1-add-support-symlinks.patch
	)
DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_prepare() {
	default
	local AT_M4DIR=${EPREFIX}/usr/share/xfce4/dev-tools/m4macros
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
