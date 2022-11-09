# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="User Tools from libqtxdg"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND=">=dev-util/lxqt-build-tools-0.11.0"
RDEPEND="
	>=dev-libs/libqtxdg-3.9.1
	>=dev-qt/qtcore-5.15:5
"
DEPEND="${RDEPEND}"
