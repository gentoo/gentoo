# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LXQt Session Manager"
HOMEPAGE="https://lxqt-project.org/"

MY_PV="$(ver_cut 1-2)"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1 LGPL-2.1+"
SLOT="0"
IUSE="+udev"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.1.0
"
DEPEND="
	>=app-misc/qtxdg-tools-4.1.0
	>=dev-libs/libqtxdg-4.1.0
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets]
	kde-frameworks/kwindowsystem:6[X]
	kde-plasma/layer-shell-qt:6
	=lxqt-base/liblxqt-${MY_PV}*:=
	sys-process/procps:=
	x11-libs/libX11
	x11-misc/xdg-user-dirs
	udev? ( virtual/libudev:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_LIBUDEV=$(usex udev)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman lxqt-config-session/man/*.1 lxqt-session/man/*.1

	newenvd - 91lxqt-config-dir <<- _EOF_
		XDG_CONFIG_DIRS='${EPREFIX}/usr/share'
	_EOF_
}
