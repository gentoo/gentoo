# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="A high-level C audio library"
HOMEPAGE="https://wickedsmoke.github.io/faun/"
SRC_URI="https://github.com/WickedSmoke/faun/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# based on COPYING file
LICENSE="MIT flac? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac"

DEPEND="
	media-libs/libpulse
	media-libs/libvorbis
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.1.2_makefile.patch"
)

src_configure() {
	tc-export CC
	# custom configure
	edo ./configure $(usex !flac --no_flac "")
}

src_install() {
	emake DESTDIR="${D}/usr" install
	dodoc README.md
}
