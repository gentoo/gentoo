# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Fast lightweight tabbed filemanager (Qt port)"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"

LICENSE="GPL-2+"
SLOT="0"

CDEPEND=">=dev-libs/glib-2.18:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=x11-libs/libfm-1.2.0:=
	x11-libs/libfm-qt:=
	x11-libs/libxcb:=
"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
	virtual/eject
	virtual/freedesktop-icon-theme"
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=NO
	)

	cmake-utils_src_configure
}
