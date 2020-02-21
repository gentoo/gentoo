# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_BUILD_TYPE=Release
inherit cmake-utils

DESCRIPTION="Terminal Emulator State Machine"
HOMEPAGE="https://github.com/Aetf/libtsm"
SRC_URI="https://github.com/Aetf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE=""
