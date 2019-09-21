# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils xdg-utils

MY_P=${PN}-${PV/_}

DESCRIPTION="A lightweight GTK+ based clipboard manager"
HOMEPAGE="http://parcellite.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.14
	>=x11-libs/gtk+-2.10:2
	x11-misc/xdotool"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i data/${PN}.desktop.in -e 's:Application;::g' || die

	sed -i -e '/^ALL_LINGUAS=/d' configure.ac || die
	strip-linguas -i po/
	export ALL_LINGUAS="${LINGUAS}"

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
