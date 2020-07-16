# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="library for managing wayfire configuration files"
HOMEPAGE="https://github.com/WayfireWM/wf-config"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wf-config.git"
else
	SRC_URI="https://github.com/WayfireWM/wf-config/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-libs/libevdev
	dev-libs/libxml2
	~gui-libs/wlroots-0.10.1
	media-libs/glm
"

RDEPEND="${DEPEND}"

BDEPEND="
	${DEPEND}
	dev-libs/wayland-protocols
	virtual/pkgconfig
"
