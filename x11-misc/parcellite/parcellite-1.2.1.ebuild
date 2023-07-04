# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

MY_P=${PN}-${PV/_}

DESCRIPTION="Lightweight GTK+ based clipboard manager"
HOMEPAGE="https://parcellite.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-misc/xdotool"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

PATCHES=( "${FILESDIR}"/${P}-desktop-QA.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}
