# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="User Tools from libqtxdg"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND=">=dev-util/lxqt-build-tools-2.0.0"
RDEPEND="
	>=dev-libs/libqtxdg-4.0.0
	>=dev-qt/qtbase-6.6:6
"
DEPEND="${RDEPEND}"
