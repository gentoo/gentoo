# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Burn CDs in disk-at-once mode -- with optional GUI frontend"
HOMEPAGE="http://cdrdao.sourceforge.net/"
if [[ ${PV/*_rc*} ]]
then
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
else
	SRC_URI="http://www.poolshark.org/src/${P/_}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="encode mad vorbis"

COMMON_DEPEND="
	virtual/cdrtools
	encode? ( >=media-sound/lame-3.99 )
	mad? (
		media-libs/libmad
		media-libs/libao
	)
	vorbis? (
		media-libs/libvorbis
		media-libs/libao
	)"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	!app-cdr/cue2toc
	!dev-util/pccts"

PATCHES=(
	"${FILESDIR}/${P}-glibc212.patch"
	"${FILESDIR}/${P}-unsigned-char.patch"
	"${FILESDIR}/${P}-ax_pthread.patch"
	"${FILESDIR}/${P}-wformat-security.patch"
	"${FILESDIR}/${P}-lame-3.100.patch"
)

S="${WORKDIR}/${P/_}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Fix building with latest libsigc++
	append-cxxflags -std=c++11
	find -name '*.h' -exec sed -i '/sigc++\/object.h/d' {} + || die

	econf \
		--without-xdao \
		$(use_with vorbis ogg-support) \
		$(use_with mad mp3-support) \
		$(use_with encode lame)
}
