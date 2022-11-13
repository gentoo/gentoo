# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

COMMIT_ID="e412923f1f792408e8ae1096ca40fb5307ddfc74"
GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="Generate waveformjs.org compatible json data out of wav files"
HOMEPAGE="https://github.com/beschulz/wav2json"
SRC_URI="https://github.com/beschulz/wav2json/archive/${COMMIT_ID}.tar.gz -> ${P}.gh@${GH_TS}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_ID}/build"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/boost:=
	media-libs/libsndfile:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	dobin ../bin/Linux/wav2json
}
