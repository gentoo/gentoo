# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada autotools multiprocessing

DESCRIPTION="A complete Ada graphical toolkit"
HOMEPAGE="http://libre.adacore.com//tools/gtkada/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE="+shared static-libs static-pic"

RDEPEND="${ADA_DEPS}
	app-accessibility/at-spi2-core
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable shared) \
		$(use_enable static-pic)
}

src_compile() {
	emake -j1 PROCESSORS=$(makeopts_jobs)
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	einstalldocs
}
