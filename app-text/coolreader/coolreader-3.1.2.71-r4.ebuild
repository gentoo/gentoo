# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"
PLOCALES="bg cs de es hu pl ru uk"
inherit cmake-utils wxwidgets l10n xdg-utils gnome2-utils

if [ "${PV}" == 9999 ]
then
	inherit git-r3
	# github mirror has some new commits to fix page margins settings
	# sourceforge mirror saved as backup
	#EGIT_REPO_URI="git://git.code.sf.net/p/crengine/crengine"
	EGIT_REPO_URI="https://github.com/buggins/coolreader.git"
	SRC_URI=""
else
	# git tag cr3.1.2-71
	SRC_URI="https://dev.gentoo.org/~grozin/${P}.tar.bz2"
fi

DESCRIPTION="CoolReader - reader of eBook files (fb2,epub,htm,rtf,txt)"
HOMEPAGE="https://sourceforge.net/projects/crengine/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wxwidgets"

DEPEND="sys-libs/zlib
	media-libs/libpng:0
	virtual/jpeg:0
	media-libs/freetype
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )
	!wxwidgets? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 )"
RDEPEND="${DEPEND}
	wxwidgets? ( || ( media-fonts/liberation-fonts media-fonts/corefonts ) )"

# 1st patch: To save cr3.ini to ~homedir.
# 2nd patch: To build QT5 and WX GUI version of coolreader3;
# setting correct vesrion number and years of cr3qt/cr3wx;
# internal switching between wxGTK 2.8 or 3.0 version;
# show wxWidgets version in "About" dialog window;
# disabling "iCCP: known incorrect sRGB profile" warning popup window for wxwidgets GUI

PATCHES=( "${FILESDIR}/cr3ini.diff" "${FILESDIR}/cr3.1.2.71-r1_qt5_wx.diff" )

for lang in ${PLOCALES}; do
	IUSE="${IUSE} l10n_${lang}"
done

src_prepare() {
	cmake-utils_src_prepare

	# locales
	l10n_find_plocales_changes "${S}"/cr3qt/src/i18n 'cr3_' '.ts'
	local lang langs
	langs=""
	for lang in ${PLOCALES}; do
		if use l10n_${lang}; then
			langs="${langs} ${lang}"
		fi
	done
	sed -e "s|SET(LANGUAGES .*)|SET(LANGUAGES ${langs})|" \
		-i "${S}"/cr3qt/CMakeLists.txt \
		|| die "sed CMakeLists.txt failed"
}

src_configure() {
	CMAKE_USE_DIR="${S}"
	CMAKE_BUILD_TYPE="Release"
	if use wxwidgets; then
		setup-wxwidgets
		local mycmakeargs=(-D GUI=WX)
	else
		local mycmakeargs=(-D GUI=QT5)
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
