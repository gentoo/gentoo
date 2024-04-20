# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Encodes audio into the Apple Lossless Audio Codec (ALAC) format"
HOMEPAGE="https://github.com/flacon/alacenc"
SRC_URI="https://github.com/flacon/alacenc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"

src_install() {
	dobin "${BUILD_DIR}/alacenc"
	einstalldocs
}
