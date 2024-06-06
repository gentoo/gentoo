# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Single file library for audio playback and capture"
HOMEPAGE="https://miniaud.io"
SRC_URI="https://github.com/mackron/miniaudio/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Unlicense MIT-0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

src_install() {
	insinto /usr/include/${PN}/
	doins -r *
}
