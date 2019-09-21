# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/fcitx/kcm-fcitx.git"
fi

DESCRIPTION="KDE configuration module for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://gitlab.com/fcitx/kcm-fcitx"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="4-plasma5"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.9:4
	>=app-i18n/fcitx-qt5-1.1:4
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/ki18n:5
	kde-frameworks/kio:5
	kde-frameworks/kitemviews:5
	kde-frameworks/knewstuff:5
	kde-frameworks/kwidgetsaddons:5
	virtual/libintl
	x11-libs/libX11
	x11-libs/libxkbfile
	!${CATEGORY}/${PN}:4[-minimal(-)]"
DEPEND="${RDEPEND}
	kde-frameworks/extra-cmake-modules:5
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_USE_QT_SYS_PATHS=yes
	)

	cmake-utils_src_configure
}
