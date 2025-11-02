# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="A high-level C audio library"
HOMEPAGE="https://wickedsmoke.codeberg.page/faun_doc/"
SRC_URI="https://codeberg.org/wickedsmoke/faun/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac"

DEPEND="
	flac? ( media-libs/flac )
	media-libs/libpulse
	media-libs/libvorbis
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.2.1_makefile.patch"
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
