# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 vcs-snapshot

DESCRIPTION="lightweight & open source microblogging client"
HOMEPAGE="http://hotot.org"
SRC_URI="https://github.com/lyricat/Hotot/tarball/452fc0924a98923b -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="chrome kde qt5"

REQUIRED_USE="|| ( chrome qt5 ) ${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_configure() {
	mycmakeargs=(
		${mycmakeargs}
		-DWITH_CHROME=$(usex chrome)
		-DWITH_KDE=$(usex kde)
		-DWITH_QT5=$(usex qt5)
		-DPYTHON_EXECUTABLE=${PYTHON} )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	find "${D}" -name "*.pyc" -delete
}

pkg_postinst() {
	if use chrome; then
		elog "TO install hotot for chrome, open chromium/google-chrome,"
		elog "vist chrome://chrome/extensions/ and load /usr/share/hotot"
		elog "as unpacked extension."
	fi
}
