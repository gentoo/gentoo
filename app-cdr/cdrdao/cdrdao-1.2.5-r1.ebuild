# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PV="rel_${PV//./_}"
DESCRIPTION="Burn CDs in disk-at-once mode with a command line interface"
HOMEPAGE="https://github.com/cdrdao/cdrdao/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="encode mad vorbis"

DEPEND="app-cdr/cdrtools
	encode? ( >=media-sound/lame-3.99 )
	mad? (
		media-libs/libao
		media-libs/libmad
	)
	vorbis? (
		media-libs/libao
		media-libs/libvorbis
	)"
RDEPEND="${DEPEND}
	!app-cdr/cue2toc"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-remove-gconf-dep.patch"
	"${FILESDIR}/${PN}-1.2.5-fix-uninit.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11

	filter-lto # https://bugs.gentoo.org/854219

	local myeconfargs=(
		--without-gcdmaster
		$(use_with vorbis ogg-support)
		$(use_with mad mp3-support)
		$(use_with encode lame)
	)
	econf "${myeconfargs[@]}"
}
