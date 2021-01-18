# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="general logout scripts for wayland compositors"

HOMEPAGE="https://github.com/soreau/wayland-logout"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/soreau/wayland-logout"
else
	SRC_URI="https://github.com/soreau/wayland-logout/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="sys-process/lsof"

src_install() {
	newbin wayland-logout.sh wayland-logout
	doman wayland-logout.1
}
