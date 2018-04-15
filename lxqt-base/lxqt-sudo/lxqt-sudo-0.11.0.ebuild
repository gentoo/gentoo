# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt GUI frontend for sudo"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

DEPEND="app-admin/sudo
	>=dev-libs/libqtxdg-1.0.0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	~lxqt-base/liblxqt-${PV}
	"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}
