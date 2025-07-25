# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Restore truncated mp4/mov files"
HOMEPAGE="https://github.com/anthwlock/untrunc"

COMMIT="13cafedf59369db478af537fb909f0d7fd0eb85f"
SRC_URI="https://github.com/anthwlock/untrunc/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-video/ffmpeg:=
"
RDEPEND="${DEPEND}"

src_install() {
	einstalldocs
	dobin untrunc
}
