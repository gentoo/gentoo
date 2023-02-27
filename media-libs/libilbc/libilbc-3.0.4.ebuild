# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TimothyGu/${PN}"
else
	SRC_URI="https://github.com/TimothyGu/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="Packaged version of iLBC codec from the WebRTC project"
HOMEPAGE="https://github.com/TimothyGu/libilbc"

LICENSE="BSD"
SLOT="0/3"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.4-respect-CFLAGS.patch"
	"${FILESDIR}/${P}-support-ia64.patch"
)
