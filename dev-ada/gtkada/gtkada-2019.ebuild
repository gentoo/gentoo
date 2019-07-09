# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multiprocessing

MYP=${P}-20190424-19D98

DESCRIPTION="A complete Ada graphical toolkit"
HOMEPAGE="http://libre.adacore.com//tools/gtkada/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5ce7f58931e87adb2d312c53
	-> ${MYP}-src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 gnat_2018 +gnat_2019 +shared static-libs"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )
	gnat_2018? ( dev-lang/gnat-gpl:7.3.1 )
	gnat_2019? ( dev-lang/gnat-gpl:8.3.1 )
	dev-libs/atk
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 gnat_2018 gnat_2019 )"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${PN}-2017-gentoo.patch )

src_prepare() {
	default
	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	if use gnat_2018; then
		GCC_PV=7.3.1
	elif use gnat_2019; then
		GCC_PV=8.3.1
	elif use gnat_2017; then
		GCC_PV=6.3.0
	else
		GCC_PV=4.9.4
	fi
	econf \
		--prefix="${D}/usr" \
		$(use_enable static-libs static) \
		$(use_enable shared) \
		--without-GL
}

src_compile() {
	GNATPREP=${CHOST}-gnatprep-${GCC_PV}
	emake -j1 GNATPREP=${GNATPREP} PROCESSORS=$(makeopts_jobs)
}

src_install() {
	emake -j1 install
	einstalldocs
}
