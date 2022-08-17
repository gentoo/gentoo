# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
HOMEPAGE="http://cdrdao.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ppc64 ~riscv sparc x86"
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
BDEPEND="gnome-base/gconf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-ax_pthread.patch"
	"${FILESDIR}/${P}-wformat-security.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11
	local myeconfargs=(
		--without-gcdmaster
		$(use_with vorbis ogg-support)
		$(use_with mad mp3-support)
		$(use_with encode lame)
	)
	econf "${myeconfargs[@]}"
}
