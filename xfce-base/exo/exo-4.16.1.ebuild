# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg-utils

DESCRIPTION="Extensions, widgets and framework library with session support for Xfce"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

RDEPEND=">=dev-libs/glib-2.50
	>=x11-libs/gtk+-3.22:3
	>=xfce-base/libxfce4ui-4.15.1:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.12:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gtk-doc-am
	dev-util/intltool
	>=dev-util/xfce4-dev-tools-4.16.0
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-4.16.0-allow-cross.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
