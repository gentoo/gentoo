# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Free open-source game based on the Sonic the Hedgehog universe"
HOMEPAGE="https://opensnc.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/project/opensnc/Open%20Sonic/${PV}/opensnc-src-${PV}.tar.gz
	mirror+https://dev.gentoo.org/~ionen/distfiles/loggcompat-4.4.2.tar.gz"
S="${WORKDIR}/opensnc-src-${PV}"

LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror" # unsure about legality of graphics

RDEPEND="
	media-libs/allegro:0[X,jpeg,png,vorbis]
	media-libs/libvorbis"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-allegro-4.4.2-loggcompat.patch # bug 711542
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	mv "${WORKDIR}"/loggcompat-4.4.2 . || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGAME_FINAL_DIR="${EPREFIX}"/usr/bin
		-DGAME_HTMLDIR="${EPREFIX}"/usr/share/doc/${PF}/html
		-DGAME_INSTALL_DIR="${EPREFIX}"/usr/share/${PN}
		-DGAME_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/${PN}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	local d
	for d in "${ED}"/usr/share/${PN}/*; do
		dosym -r /usr/{share,$(get_libdir)}/${PN}/${d##*/}
	done
}
