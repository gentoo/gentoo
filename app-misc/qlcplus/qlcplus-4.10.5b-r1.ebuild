# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils udev vcs-snapshot virtualx

DESCRIPTION="QLC+ - Q Light Controller Plus to control DMX interfaces"
HOMEPAGE="http://www.qlcplus.org/"
SRC_URI="https://github.com/mcallegari/${PN}/archive/QLC+_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	|| ( dev-embedded/libftdi:1 dev-embedded/libftdi:0 )
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-libs/libmad
	media-libs/libsndfile
	sci-libs/fftw:3.0
	virtual/libusb:0
	virtual/libusb:1
	virtual/udev
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e "s:/etc/udev/rules.d:${EROOT}lib/udev/rules.d:" -i \
		plugins/hid/hid.pro \
		plugins/udmx/src/src.pro \
		plugins/dmxusb/src/src.pro \
		plugins/spi/spi.pro \
		plugins/peperoni/unix/unix.pro || die
	sed -e "/UDEVRULESDIR/s:/etc/udev/rules.d:$(get_udevdir)/rules.d:" \
		-i variables.pri || die
}

src_configure() {
	eqmake5
}

src_test() {
	virtx emake check
}
