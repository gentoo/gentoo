# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/deskflow/deskflow.git"
	inherit git-r3
else
	SRC_URI="https://github.com/deskflow/deskflow/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Share a mouse and keyboard between computers (FOSS version of Synergy)"
HOMEPAGE="https://github.com/deskflow/deskflow"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	>=dev-libs/libei-0.99.1
	dev-libs/libportal:=
	dev-libs/openssl:0=
	dev-qt/qtbase:6[dbus,network,xml]
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	dev-qt/qtbase:6[gui,widgets]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	dev-cpp/cli11
	x11-base/xorg-proto
	test? ( dev-cpp/gtest )
"
BDEPEND="
	virtual/pkgconfig
	dev-qt/qttools:6[linguist]
"

DOCS=(
	README.md
	doc/user/configuration.md
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		$(usex test -DSKIP_BUILD_TESTS=ON "")
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/bin/legacytests || die
	BUILD_DIR+=/src/unittests virtx cmake_src_test
}
