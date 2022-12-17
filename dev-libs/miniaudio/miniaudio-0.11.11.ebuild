# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A single file library for audio playback and capture."
HOMEPAGE="https://miniaudio.io"
COMMIT="a0dc1037f99a643ff5fad7272cd3d6461f2d63fa"
SRC_URI="https://github.com/mackron/miniaudio/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	insinto /usr/include/${PN}/
	doins -r *
}
