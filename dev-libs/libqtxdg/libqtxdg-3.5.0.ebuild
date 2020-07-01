# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake virtualx

DESCRIPTION="Qt Implementation of XDG Standards"
HOMEPAGE="https://lxqt.github.io/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1+ Nokia-Qt-LGPL-Exception-1.1"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-util/lxqt-build-tools-0.7.0
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5=
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	x11-misc/xdg-utils
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	# Tests don't work with C
	LC_ALL=en_US.utf8 virtx cmake_src_test
}
