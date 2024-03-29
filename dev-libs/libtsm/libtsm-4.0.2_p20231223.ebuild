# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="69922bde02c7af83b4d48a414cc6036af7388626"

DESCRIPTION="Terminal Emulator State Machine"
HOMEPAGE="https://github.com/Aetf/libtsm"
SRC_URI="https://github.com/Aetf/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${COMMIT}

LICENSE="LGPL-2.1 MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}/${PN}-cmake.patch" )
