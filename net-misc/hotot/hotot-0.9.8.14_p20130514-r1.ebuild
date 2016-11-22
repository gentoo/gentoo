# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 vcs-snapshot

DESCRIPTION="lightweight & open source microblogging client"
HOMEPAGE="http://hotot.org"
SRC_URI="https://github.com/lyricat/Hotot/tarball/ed2ff013 -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chrome kde qt4"

REQUIRED_USE="|| ( chrome qt4 ) ${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	qt4? ( dev-qt/qtwebkit:4
		kde? ( kde-base/kdelibs ) )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	qt4? ( dev-qt/qtsql:4 )
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	mycmakeargs=(
		${mycmakeargs}
		$(cmake-utils_use_with chrome CHROME)
		-DWITH_GTK=OFF
		-DWITH_GTK2=OFF
		-DWITH_GTK3=OFF
		$(cmake-utils_use_with kde KDE)
		$(cmake-utils_use_with qt4 QT)
		-DPYTHON_EXECUTABLE=${PYTHON} )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	find "${D}" -name "*.pyc" -print -delete
}

pkg_postinst() {
	if use chrome; then
		elog "TO install hotot for chrome, open chromium/google-chrome,"
		elog "vist chrome://chrome/extensions/ and load /usr/share/hotot"
		elog "as unpacked extension."
	fi
}
