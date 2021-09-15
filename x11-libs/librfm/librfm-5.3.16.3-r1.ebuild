# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

MY_P="${PN}5-${PV}"

DESCRIPTION="The basic library used by some rfm applications, such as Rodent filemanager"
HOMEPAGE="http://xffm.org/libxffm.html"
SRC_URI="mirror://sourceforge/xffm/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.22.5:2
	>=dev-libs/libdbh-5.0.13
	>=dev-libs/libtubo-5.0.13
	>=dev-libs/libxml2-2.4.0:2
	>=dev-libs/libzip-0.9:0=
	>=gnome-base/librsvg-2.26:2
	>=x11-libs/cairo-1.12.6[X]
	>=x11-libs/gtk+-3.12:3[X]
	>=x11-libs/pango-1.28.0[X]
	!<x11-misc/rodent-5
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i -e "s|-O2|${CFLAGS}|" m4/rfm-conditionals.m4 || die
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
