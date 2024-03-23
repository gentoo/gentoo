# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.org https://github.com/flameshot-org/flameshot"
SRC_URI="https://github.com/flameshot-org/flameshot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 Free-Art-1.3 GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="wayland"

DEPEND="
	=dev-qt/qtsingleapplication-2.6*[qt5(+),X]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	sys-apps/dbus
	wayland? ( kde-frameworks/kguiaddons:5 )
"
BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -r external/singleapplication || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859613
	# https://github.com/flameshot-org/flameshot/issues/3531
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DUSE_EXTERNAL_SINGLEAPPLICATION=1
		-DENABLE_CACHE=0
		-DUSE_WAYLAND_CLIPBOARD=$(usex wayland)
	)

	cmake_src_configure
}
