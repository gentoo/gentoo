# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils udev virtualx xdg

DESCRIPTION="A software to control DMX or analog lighting systems"
HOMEPAGE="https://www.qlcplus.org/"
SRC_URI="https://github.com/mcallegari/${PN}/archive/QLC+_${PV}.tar.gz"
S="${WORKDIR}/qlcplus-QLC-_${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-embedded/libftdi:=
	dev-libs/glib:2
	dev-qt/qt3d:5[qml]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets,qml]
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-libs/libmad
	media-libs/libsndfile
	sci-libs/fftw:3.0
	virtual/libusb:0
	virtual/libusb:1
	virtual/udev
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
}

src_configure() {
	eqmake5 CONFIG+=qmlui
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

src_test() {
	virtx emake check
}

pkg_postinst() {
	elog "Some configurations of KDE Plasma break the layout of"
	elog "QLC+ 5's QML UI."
	elog "As a workaround, try those environment variables:"
	elog "	export XDG_CURRENT_DESKTOP=GNOME"
	elog "OR"
	elog "	export QT_QPA_PLATFORMTHEME=gtk3"
}
