# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Console app for playing FLAC audio files"
HOMEPAGE="https://flac-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/flac-tools/${P}-release.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc ppc64 sparc x86"

RDEPEND="
	dev-libs/popt
	media-libs/flac:=
	media-libs/libao
	media-libs/libogg"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}
