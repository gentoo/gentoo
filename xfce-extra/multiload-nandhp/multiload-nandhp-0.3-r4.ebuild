# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

MY_PV=version-${PV/./-}

DESCRIPTION="A port of the GNOME multiload applet for the Xfce panel"
HOMEPAGE="https://github.com/nandhp/multiload-nandhp"
SRC_URI="https://github.com/nandhp/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.14:2=
	x11-libs/cairo:=
	>=gnome-base/libgtop-2.11.92:=
	<xfce-base/libxfce4ui-4.15:=[gtk2(+)]
	>=xfce-base/libxfce4util-4.10:=
	<xfce-base/xfce4-panel-4.15:=[gtk2(+)]"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS README.md )

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-xfce4
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
