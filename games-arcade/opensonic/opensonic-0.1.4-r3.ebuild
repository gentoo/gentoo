# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Free open-source game based on the Sonic the Hedgehog universe"
HOMEPAGE="http://opensnc.sourceforge.net/home/index.php"
SRC_URI="https://sourceforge.net/projects/opensnc/files/Open%20Sonic/${PV}/opensnc-src-${PV}.tar.gz
	https://github.com/t6/loggcompat/archive/4.4.2.tar.gz -> loggcompat-4.4.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror" # unsure about legality of graphics

DEPEND="
	media-libs/allegro:0=[X,jpeg,png,vorbis]
	media-libs/libogg:=
	media-libs/libpng:0=
	media-libs/libvorbis:=
	sys-libs/zlib:=
	virtual/jpeg:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/opensnc-src-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-allegro-4.4.2-loggcompat.patch # bug 711542
)

src_prepare() {
	mv "${WORKDIR}"/loggcompat-4.4.2 . || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGAME_INSTALL_DIR="${EPREFIX}"/usr/share/${PN}
		-DGAME_FINAL_DIR="${EPREFIX}"/usr/bin
		-DGAME_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/${PN}
		-DGAME_HTMLDIR="${EPREFIX}"/usr/share/doc/${PF}/html
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	local f
	while IFS="" read -d $'\0' -r f; do
		dosym ../../share/${PN}/${f##*/} /usr/$(get_libdir)/${PN}/${f##*/}
	done < <(find "${ED}"/usr/share/${PN}/ -mindepth 1 -maxdepth 1 -type d -print0)
}
