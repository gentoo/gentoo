# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils virtualx

DESCRIPTION="A Qt implementation of XDG standards"
HOMEPAGE="https://lxqt.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

CDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_test() {
	VIRTUALX_COMMAND="cmake-utils_src_test" virtualmake
}
