# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils gnome2-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-unikey"
fi

DESCRIPTION="Vietnamese Unikey input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-unikey"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+ GPL-3+ LGPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+macro-editor"

RDEPEND=">=app-i18n/fcitx-4.2.9:4
	virtual/libintl
	macro-editor? (
		>=app-i18n/fcitx-qt5-1.1:4
		>=dev-qt/qtcore-5.7:5
		>=dev-qt/qtgui-5.7:5
		>=dev-qt/qtwidgets-5.7:5
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=()

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT=$(usex macro-editor)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
