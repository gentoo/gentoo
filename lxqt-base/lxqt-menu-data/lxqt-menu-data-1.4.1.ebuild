# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake

DESCRIPTION="LXQt Menu Files and Translations for Menu Categories"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND="
	>=dev-util/lxqt-build-tools-0.13.0
	>=dev-qt/linguist-tools-5.15:5
"
RDEPEND="
	!<lxqt-base/lxqt-config-1.4.0
	!<lxqt-base/lxqt-panel-1.4.0
	!<x11-misc/pcmanfm-qt-1.4.0
"
