# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${PN}5-${PV}"

DESCRIPTION="The basic library used by some rfm applications, such as Rodent filemanager"
HOMEPAGE="http://xffm.org/libxffm.html"
SRC_URI="mirror://sourceforge/xffm/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-libs/glib-2.22.5:2
	>=dev-libs/libdbh-5.0.13
	>=dev-libs/libtubo-5.0.13
	>=dev-libs/libxml2-2.4.0:2
	>=dev-libs/libzip-0.9:0=
	>=gnome-base/librsvg-2.26:2
	>=x11-libs/cairo-1.12.6[X]
	>=x11-libs/gtk+-3.12:3[X]
	>=x11-libs/pango-1.28.0[X]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-C99-decls.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
