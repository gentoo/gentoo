# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="library for managing wayfire configuration files"
HOMEPAGE="https://github.com/WayfireWM/wf-config"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wf-config.git"
	SLOT="0/9999"
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
	dev-libs/libxml2
	media-libs/glm
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
	test? ( dev-cpp/doctest )
"

src_configure() {
	local emesonargs=(
		$(meson_feature test tests)
		-Dlocale_test=false # requires de_DE locale to be installed
	)

	meson_src_configure
}
