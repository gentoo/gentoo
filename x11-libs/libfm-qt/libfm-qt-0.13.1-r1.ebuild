# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="Qt port of libfm, a library providing components to build desktop file managers"
HOMEPAGE="https://lxqt.org/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/5"

PATCHES=(
	"${FILESDIR}/${P}-check-if-app-exists-before-opening.patch"
	"${FILESDIR}/${P}-fix-smb-error.patch"
	"${FILESDIR}/${P}-correctly-handle-mountable-types.patch"
)

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=lxde-base/menu-cache-1.1.0
	media-libs/libexif:=
	>=x11-libs/libfm-1.2.0:=
	x11-libs/libxcb:=
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.5.0
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=OFF
	)
	cmake-utils_src_configure
}
