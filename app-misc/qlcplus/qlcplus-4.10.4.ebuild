# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils qt4-r2 eutils virtualx

DESCRIPTION="QLC+ - Q Light Controller Plus to control DMX interfaces"
HOMEPAGE="http://www.qlcplus.org/"
SRC_URI="http://www.${PN}.org/downloads/${PV}/${PN}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="dev-libs/glib:2
	virtual/libusb:0
	virtual/libusb:1
	media-libs/alsa-lib
	media-libs/libmad
	media-libs/libsndfile
	sci-libs/fftw:3.0
	virtual/udev
	|| ( dev-embedded/libftdi:1 dev-embedded/libftdi:0 )
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtscript:4
		dev-qt/qttest:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5[widgets]
		dev-qt/qtnetwork:5
		dev-qt/qtscript:5
		dev-qt/qttest:5
		dev-qt/qtwidgets:5 )"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${P/b/}

src_prepare() {
	sed -e "s:/etc/udev/rules.d:${EROOT}lib/udev/rules.d:" -i \
		plugins/hid/hid.pro \
		plugins/udmx/src/src.pro \
		plugins/dmxusb/src/src.pro \
		plugins/spi/spi.pro \
		plugins/peperoni/unix/unix.pro || die
}

src_configure() {
	use qt5 && eqmake5
	use qt4 && eqmake4
}

src_test() {
	Xemake check
}
