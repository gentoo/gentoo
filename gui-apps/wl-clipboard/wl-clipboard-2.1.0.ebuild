# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Wayland clipboard utilities"
HOMEPAGE="https://github.com/bugaevc/wl-clipboard"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bugaevc/${PN}.git"
else
	SRC_URI="https://github.com/bugaevc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-libs/wayland"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/wayland-scanner"
