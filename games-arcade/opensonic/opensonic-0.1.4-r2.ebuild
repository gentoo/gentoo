# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN=opensnc
MY_P=${MY_PN}-src-${PV}

DESCRIPTION="A free open-source game based on the Sonic the Hedgehog universe"
HOMEPAGE="http://opensnc.sourceforge.net/"
SRC_URI="https://sourceforge.net/projects/opensnc/files/Open%20Sonic/${PV}/opensnc-src-${PV}.tar.gz"

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
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}
PATCHES=( "${FILESDIR}"/${PN}-0.1.4-r1-cmake.patch )

src_configure() {
	local mycmakeargs=(
		-DGAME_INSTALL_DIR="${EPREFIX}"/usr/share/${PN}
		-DGAME_FINAL_DIR="${EPREFIX}"/usr/bin
		-DGAME_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/${PN}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local f
	while IFS="" read -d $'\0' -r f; do
		dosym ../../share/${PN}/${f##*/} \
			/usr/$(get_libdir)/${PN}/${f##*/}
	done < <(find "${ED%/}"/usr/share/${PN}/ -mindepth 1 -maxdepth 1 -type d -print0)
}
