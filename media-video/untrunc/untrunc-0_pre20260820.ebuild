# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="Restore truncated mp4/mov files"
HOMEPAGE="https://github.com/anthwlock/untrunc"

COMMIT="9d86ec9ef2ffed1bf8131abe80742c0574db52b6"
SRC_URI="https://github.com/anthwlock/untrunc/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=media-video/ffmpeg-6.1:=
"
RDEPEND="${DEPEND}"

src_install() {
	einstalldocs
	dobin untrunc
}
