# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="lightweight & open source microblogging client"
HOMEPAGE="http://hotot.org"
EGIT_REPO_URI="git://github.com/lyricat/Hotot.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="chrome gtk2 gtk3 kde qt4 qt5"

REQUIRED_USE="|| ( chrome gtk2 gtk3 qt4 qt5 ) ${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	gtk2? ( dev-python/pywebkitgtk[${PYTHON_USEDEP}] )
	gtk3? ( dev-python/pygobject:3[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
		net-libs/webkit-gtk:3[introspection] )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
		kde? ( kde-frameworks/kdelibs:4 ) )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext
	qt4? ( dev-qt/qtsql:4 )"

src_configure() {
	mycmakeargs=(
		${mycmakeargs}
		-DWITH_CHROME=$(usex chrome)
		-DWITH_GTK=$(usex gtk2)
		-DWITH_GTK2=$(usex gtk2)
		-DWITH_GTK3=$(usex gtk3)
		-DWITH_KDE=$(usex kde)
		-DWITH_QT=$(usex qt4)
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
