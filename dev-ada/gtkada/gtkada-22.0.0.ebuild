# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0..1} gcc_12_2_0 )
inherit ada autotools multiprocessing

DESCRIPTION="A complete Ada graphical toolkit"
HOMEPAGE="http://libre.adacore.com//tools/gtkada/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"

RDEPEND="${ADA_DEPS}
	dev-libs/atk
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

PATCHES=(
	"${FILESDIR}"/${PN}-2017-r1-gentoo.patch
	"${FILESDIR}"/${PN}-2019-gentoo.patch
	"${FILESDIR}"/${PN}-2021-uninstall.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable shared) \
		$(use_enable static-pic) \
		--without-GL
}

src_compile() {
	emake -j1 PROCESSORS=$(makeopts_jobs)
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	einstalldocs
}
