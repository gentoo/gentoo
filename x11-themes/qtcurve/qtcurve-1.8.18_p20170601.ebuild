# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A set of widget styles for Qt and GTK2"
HOMEPAGE="https://github.com/QtCurve/qtcurve"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/QtCurve/qtcurve.git"
else
	SRC_URI="https://dev.gentoo.org/~kensington/distfiles/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+X gtk nls +qt4 qt5"
REQUIRED_USE="gtk? ( X )
	|| ( gtk qt4 qt5 )"

RDEPEND="X? (
		x11-libs/libxcb
		x11-libs/libX11
	)
	gtk? ( x11-libs/gtk+:2 )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? ( dev-qt/qtdbus:5
			dev-qt/qtx11extras:5 )
	)
	!x11-themes/gtk-engines-qtcurve"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

PATCHES=( "${FILESDIR}/${P}-include.patch" )

src_configure() {
	local mycmakeargs=(
		-DQTC_ENABLE_X11=$(usex X)
		-DQTC_INSTALL_PO=$(usex nls)
		-DQTC_QT4_ENABLE_KDE=OFF
		-DQTC_QT4_ENABLE_KWIN=OFF
		-DQTC_QT5_ENABLE_KDE=OFF
		-DENABLE_GTK2=$(usex gtk)
		-DENABLE_QT4=$(usex qt4)
		-DENABLE_QT5=$(usex qt5)
	)
	cmake-utils_src_configure
}
