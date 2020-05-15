# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="library for managing wayfire configuration files"
HOMEPAGE="https://github.com/WayfireWM/wf-config"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-libs/libevdev
	dev-libs/libxml2
	gui-libs/wlroots
	media-libs/glm
"

RDEPEND="${DEPEND}"

BDEPEND="
	${DEPEND}
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

src_compile () {
	local emesonargs=""
	if use debug; then
		emesonargs+=(
			"-Db_sanitize=address,undefined"
		)
	fi
	meson_src_compile
}
