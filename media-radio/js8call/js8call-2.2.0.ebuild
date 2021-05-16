# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils vcs-snapshot

MY_P=${P/_/-}

DESCRIPTION="Weak signal ham radio communication"
HOMEPAGE="https://groups.io/g/js8call"
SRC_URI="https://bitbucket.org/widefido/js8call/get/v${PV}-ga.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtserialport:5
	dev-qt/qtprintsupport:5
	virtual/libusb:1
	media-libs/portaudio
	sci-libs/fftw:3.0[threads,fortran]
	virtual/fortran
	app-text/asciidoc
	<media-libs/hamlib-3.4
	doc? ( dev-ruby/asciidoctor )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-hamlib-type.patch" )

src_install() {
	cmake-utils_src_install
	rm "${D}"/usr/bin/rigctl{,d}-local || die
}
