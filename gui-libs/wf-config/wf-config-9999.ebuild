# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit locale-utils meson

DESCRIPTION="library for managing wayfire configuration files"
HOMEPAGE="https://github.com/WayfireWM/wf-config"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wf-config.git"
	SLOT="0/0.12"
else
	SRC_URI="https://github.com/WayfireWM/wf-config/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libevdev
	dev-libs/libxml2:=
	media-libs/glm
"
RDEPEND="
	${DEPEND}
	!gui-wm/wayfire:0/0.9
"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
	test? ( dev-cpp/doctest )
"

src_configure() {
	local emesonargs=(
		$(meson_feature test tests)
		$(meson_use elibc_glibc locale_test)
	)

	meson_src_configure
}

src_test() {
	local -x LOCPATH
	elocale_gen fr_FR.UTF-8
	meson_src_test
}
