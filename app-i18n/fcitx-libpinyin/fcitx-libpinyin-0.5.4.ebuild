# Copyright 2012-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-libpinyin"
fi

DESCRIPTION="Chinese LibPinyin input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-libpinyin"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI="https://download.fcitx-im.org/data/model.text.20161206.tar.gz -> fcitx-data-model.text.20161206.tar.gz"
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}_dict.tar.xz"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="dictionary-manager"

BDEPEND=">=app-i18n/fcitx-4.2.9:4
	>=app-i18n/libpinyin-2.1.0
	virtual/pkgconfig
	dictionary-manager? (
		>=dev-qt/qtcore-5.7:5
		>=dev-qt/qtwidgets-5.7:5
	)"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	>=app-i18n/libpinyin-2.1.0:=
	dev-libs/glib:2
	sys-apps/dbus
	virtual/libintl
	dictionary-manager? (
		>=app-i18n/fcitx-qt5-1.1:4
		>=dev-qt/qtcore-5.7:5
		>=dev-qt/qtdbus-5.7:5
		>=dev-qt/qtgui-5.7:5
		>=dev-qt/qtnetwork-5.7:5
		>=dev-qt/qtwebengine-5.7:5[widgets]
		>=dev-qt/qtwidgets-5.7:5
	)"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS)

src_prepare() {
	if [[ "${PV}" =~ (^|\.)9999$ ]]; then
		ln -s "${DISTDIR}/fcitx-data-model.text.20161206.tar.gz" data/model.text.20161206.tar.gz || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT=$(usex dictionary-manager)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
