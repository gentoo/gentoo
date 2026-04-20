# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature virtualx

# The notice is triggered by an example file, which is unused here.
# https://bugs.gentoo.org/951350
CMAKE_QA_COMPAT_SKIP=1

DESCRIPTION="Qt Implementation of XDG Standards"
HOMEPAGE="
	https://lxqt-project.org/
	https://github.com/lxqt/libqtxdg/
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+ Nokia-Qt-LGPL-Exception-1.1"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-util/lxqt-build-tools-2.4.0
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-6.6:6=[dbus,gui,widgets,xml]
	>=dev-qt/qtsvg-6.6:6
	x11-misc/xdg-utils
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	# Tests don't work with C
	LC_ALL=en_US.UTF-8 virtx cmake_src_test
}

pkg_postinst() {
	! has_version lxqt-base/lxqt-meta && optfeature "features that require a terminal emulator" x11-terms/xterm
}
