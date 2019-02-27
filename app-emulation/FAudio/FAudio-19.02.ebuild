# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib cmake-utils

DESCRIPTION="FAudio is an XAudio reimplementation of DirectX Audio runtime libraries."
HOMEPAGE="https://github.com/FNA-XNA/FAudio"
SRC_URI="https://github.com/FNA-XNA/FAudio/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl2"
