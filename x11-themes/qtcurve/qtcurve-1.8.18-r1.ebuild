# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils

DESCRIPTION="A set of widget styles for Qt and GTK2"
HOMEPAGE="https://github.com/QtCurve/qtcurve"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/QtCurve/qtcurve.git"
else
	SRC_URI="https://github.com/QtCurve/${PN}/archive/${PV/_/}.tar.gz  -> ${P}.tar.gz
		https://github.com/QtCurve/qtcurve/commit/020b70404f6202490d5ca131f0ec084355cb98e3.patch -> ${PN}-1.8.18-dont_use_c++11.patch"
	KEYWORDS="alpha amd64 hppa ppc ppc64 ~sparc x86"
fi

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+X gtk nls +qt4 qt5"
REQUIRED_USE="gtk? ( X )
	|| ( gtk qt4 qt5 )"

RDEPEND="X? ( x11-libs/libxcb
		x11-libs/libX11 )
	gtk? ( x11-libs/gtk+:2 )
	qt4? ( dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
	)
	qt5? ( dev-qt/qtdeclarative:5
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

S="${WORKDIR}/${P/_/}"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

PATCHES=(
	"${DISTDIR}/${P}-dont_use_c++11.patch"
	"${FILESDIR}/${P}-remove_qt_filedialog_api.patch"
	"${FILESDIR}/${P}-gtk2_segfault.patch"
	"${FILESDIR}/${P}-std_isnan.patch"
	"${FILESDIR}/${P}-glibc-2.23.patch"
	)

pkg_setup() {
	# bug #498776
	if ! version_is_at_least 4.7 $(gcc-version) ; then
		append-cxxflags -Doverride=
	fi
}

src_configure() {
	local mycmakeargs=(
		-DQTC_QT4_ENABLE_KDE=OFF
		-DQTC_QT4_ENABLE_KWIN=OFF
		$(cmake-utils_use_enable gtk GTK2)
		$(cmake-utils_use_enable qt4 QT4)
		$(cmake-utils_use_enable qt5 QT5)
		$(cmake-utils_use X QTC_ENABLE_X11 )
		$(cmake-utils_use nls QTC_INSTALL_PO )
	)
	cmake-utils_src_configure
}
