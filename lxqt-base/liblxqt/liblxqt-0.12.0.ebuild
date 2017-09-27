# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Common base library for the LXQt desktop environment"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+ BSD"
SLOT="0"

RDEPEND=">=dev-libs/libqtxdg-3.1.0:=
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	dev-qt/qtxml:5=
	kde-frameworks/kwindowsystem:5=[X]
	x11-libs/libXScrnSaver
	!!lxqt-base/lxqt-common
"
DEPEND="${RDEPEND}
	>=dev-util/lxqt-build-tools-0.4.0
	dev-qt/linguist-tools:5="

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}
