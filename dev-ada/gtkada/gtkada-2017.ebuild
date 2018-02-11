# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="A complete Ada graphical toolkit"
HOMEPAGE="http://libre.adacore.com//tools/gtkada/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591ae7a8c7a4473fcbb154c9
	-> ${MYP}-src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnat_2016 +gnat_2017 +shared static-libs"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )
	dev-libs/atk
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016=,gnat_2017=]"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 )"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
	GCC=${CHOST}-gcc-${GCC_PV}
	econf \
		--prefix="${D}/usr" \
		$(use_enable static-libs static) \
		$(use_enable shared) \
		--without-GL
}

src_compile() {
	GNATPREP=${CHOST}-gnatprep-${GCC_PV}
	GCC=${GCC} emake -j1 GNATPREP=${GNATPREP} PROCESSORS=$(makeopts_jobs)
}

src_install() {
	emake -j1 install
	einstalldocs
}
