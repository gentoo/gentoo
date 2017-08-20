# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xfconf

DESCRIPTION="A clipboard manager plug-in for the Xfce panel"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-clipman-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug qrcode"

RDEPEND=">=dev-libs/glib-2.18
	dev-libs/libunique:1
	>=x11-libs/gtk+-2.14:2
	x11-libs/libXtst
	>=xfce-base/exo-0.10
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfce4-panel-4.10
	>=xfce-base/xfconf-4.10
	qrcode? ( >=media-gfx/qrencode-3.3.0 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

pkg_setup() {
	XFCONF=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable qrcode libqrencode)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}
