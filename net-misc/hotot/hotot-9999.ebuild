# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-2 python-single-r1

DESCRIPTION="lightweight & open source microblogging client"
HOMEPAGE="http://hotot.org"
EGIT_REPO_URI="git://github.com/lyricat/Hotot.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="chrome gtk kde qt4"

REQUIRED_USE="|| ( chrome gtk qt4 ) ${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	gtk? ( dev-python/pywebkitgtk[${PYTHON_USEDEP}] )
	qt4? ( dev-qt/qtwebkit:4
		kde? ( kde-base/kdelibs ) )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	qt4? ( dev-qt/qtsql:4 )"

pkg_setup() {
	if ! use gtk ; then
		if ! use qt4 ; then
			ewarn "neither gtk not qt4 binaries will be build"
		fi
	fi
	python-single-r1_pkg_setup
}

src_configure() {
	mycmakeargs=(
		${mycmakeargs}
		$(cmake-utils_use_with chrome CHROME)
		$(cmake-utils_use_with gtk GTK)
		$(cmake-utils_use_with gtk GTK2)
		-DWITH_GTK3=OFF
		$(cmake-utils_use_with kde KDE)
		$(cmake-utils_use_with qt4 QT)
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
