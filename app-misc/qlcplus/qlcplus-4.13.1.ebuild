# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils udev virtualx xdg

DESCRIPTION="A software to control DMX or analog lighting systems"
HOMEPAGE="https://www.qlcplus.org/"
SRC_URI="https://github.com/mcallegari/${PN}/archive/QLC+_${PV}.tar.gz"
S="${WORKDIR}/qlcplus-QLC-_${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-embedded/libftdi:1
	dev-qt/qtcore:5
	dev-qt/qtgui:5[jpeg]
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtserialport:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-libs/libmad
	media-libs/libsndfile
	sci-libs/fftw:3.0=
	virtual/libusb:1
	virtual/udev
"
IDEPEND="
	dev-util/desktop-file-utils
"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
"

src_prepare() {
	default

	sed -e "/UDEVRULESDIR/s:/etc/udev/rules.d:$(get_udevdir)/rules.d:" \
		-i variables.pri || die

	## Remove Werror-flag since there are some warnings with gcc-9.x
	sed -e "s/QMAKE_CXXFLAGS += -Werror/#&/g" \
		-i variables.pri || die

	## Remove Werror-flag since there are some warnings with gcc-9.x
	sed -e "s/unix:QMAKE_CFLAGS += -Werror/#&/g" \
		-i variables.pri || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	udev_reload

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

src_test() {
	virtx emake check
}

pkg_postrm() {
	udev_reload

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
