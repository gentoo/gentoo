# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Console app for playing FLAC audio files"
HOMEPAGE="https://github.com/flac123/flac123"
SRC_URI="https://github.com/flac123/flac123/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc ppc64 sparc x86"

RDEPEND="
	dev-libs/popt
	media-libs/flac:=[ogg]
	media-libs/libao"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf
}
