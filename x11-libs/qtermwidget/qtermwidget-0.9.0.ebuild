# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Qt terminal emulator widget"
HOMEPAGE="https://github.com/lxqt/qtermwidget"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/${PV}"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	>=dev-util/lxqt-build-tools-0.5.0
	dev-qt/linguist-tools:5
"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=OFF
	)
	cmake-utils_src_configure
}
