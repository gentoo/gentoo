# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

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
	wxwidgets? ( || ( x11-libs/wxGTK:3.0 x11-libs/wxGTK:2.8 ) )
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

src_configure() {
	CMAKE_USE_DIR="${S}"
	CMAKE_BUILD_TYPE="Release"
	if use wxwidgets; then
		. "${ROOT}/var/lib/wxwidgets/current"
		if [[ "${WXCONFIG}" -eq "none" ]]; then
		   	die "The wxGTK profile should be selected!"
		fi
		local mycmakeargs=(-D GUI=WX)
	else
		local mycmakeargs=(-D GUI=QT5)
	fi
	cmake-utils_src_configure
}
