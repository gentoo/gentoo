# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}2-${PV}"
inherit desktop qmake-utils toolchain-funcs xdg

DESCRIPTION="Tool to render 3D fractals"
HOMEPAGE="https://www.mandelbulber.com"
SRC_URI="https://github.com/buddhi1980/${PN}2/releases/download/${PV}/${MY_P}.tar.gz mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="CC-BY-4.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="joystick opencl openexr sndfile tiff"

RDEPEND="
	dev-libs/lzo
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	media-libs/libpng:=
	sci-libs/gsl:=
	joystick? ( dev-qt/qtgamepad:5 )
	opencl? (
		dev-cpp/clhpp
		virtual/opencl
	)
	openexr? (
		dev-libs/imath:=
		media-libs/openexr:=
	)
	sndfile? ( media-libs/libsndfile )
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}
	dev-qt/designer:5
"
BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_prepare() {
	default

	use joystick || sed -i -e "s/qtHaveModule(gamepad)/false/" makefiles/common.pri || die
	use openexr || sed -i -e "s/packagesExist(OpenEXR)/false/" makefiles/common.pri || die
	use sndfile || sed -i -e "s/packagesExist(sndfile)/false/" makefiles/common.pri || die
	use tiff || sed -i -e "s/packagesExist(libtiff-4)/false/" makefiles/common.pri || die
}

src_configure() {
	if use opencl; then
		eqmake5 makefiles/${PN}-opencl.pro
	else
		eqmake5 makefiles/${PN}.pro
	fi
}

src_install() {
	dobin ${PN}2

	dodoc README NEWS usr/share/doc/${PN}2/Mandelbulber_Manual.pdf

	insinto /usr/share/${PN}2
	doins -r usr/share/${PN}2/*

	domenu ${PN}2.desktop

	newicon -s 256 qt/icons/${PN}.png ${PN}2.png
}
