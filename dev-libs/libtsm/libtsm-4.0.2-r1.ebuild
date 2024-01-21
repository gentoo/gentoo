# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Terminal Emulator State Machine"
HOMEPAGE="https://github.com/Aetf/libtsm"
SRC_URI="https://github.com/Aetf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-cmake.patch"
	"${FILESDIR}/${PN}-clang16-static_assert-fix.patch"
)
