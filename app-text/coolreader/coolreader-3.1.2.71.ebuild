# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [ "${PV}" == 9999 ]
then
	inherit git
	EGIT_REPO_URI="git://crengine.git.sourceforge.net/gitroot/crengine/crengine"
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
IUSE="qt4 qt5 wxwidgets corefonts"
REQUIRED_USE="^^ ( qt4 qt5 wxwidgets )
	wxwidgets? ( corefonts )"

DEPEND="sys-libs/zlib
	media-libs/libpng:0
	virtual/jpeg:0
	media-libs/freetype
	wxwidgets? (
		|| ( x11-libs/wxGTK:3.0 x11-libs/wxGTK:2.8 ) )
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5 )"
RDEPEND="${DEPEND}
	corefonts? ( media-fonts/corefonts )"

src_prepare() {
	# setting patch to save cr3.ini to ~homedir
	epatch "${FILESDIR}/cr3ini.diff"
	# patch to build QT5 and WX GUI version of coolreader3
	# and setting correct vesrion number and years of cr3qt/cr3wx
	epatch "${FILESDIR}/cr3.1.2.71-r1_qt5_wx.diff"
	if [ $(eselect wxwidgets list | grep '*' | cut -d ' ' -f 6) == "gtk2-unicode-3.0" ]; then
		# patch if wxGTK3.0 (not wxGTK2.8) is active eselect profile
		epatch "${FILESDIR}/cr3.1.2.71_wxGTK3.diff"
	fi
	eapply_user
}

src_configure() {
	CMAKE_USE_DIR="${S}"
	CMAKE_BUILD_TYPE="Release"
	if use qt4; then
		local mycmakeargs=(-D GUI=QT)
	elif use qt5; then
		local mycmakeargs=(-D GUI=QT5)
	elif use wxwidgets; then
		. "${ROOT}/var/lib/wxwidgets/current"
		if [[ "${WXCONFIG}" -eq "none" ]]; then
		   	die "The wxGTK profile should be selected!"
		fi
		local mycmakeargs=(-D GUI=WX)
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym ../fonts/corefonts /usr/share/crengine/fonts
	elog
}

pkg_postinst() {
if use wxwidgets; then
	elog ""
	elog "KNOWN ISSUE TO FIX:"
	elog "With wxwidgets gui you can see a warning message \"iCCP: known incorrect sRGB profile\""
	elog "that appears if \"Toolbar size\" is setting to \"Medium buttons\" in Options."
	elog "To avoid appearing of this warning popup window you can change \"Toolbar size\" or set it to \"Hide Toolbar\"."
	elog ""
fi
}
