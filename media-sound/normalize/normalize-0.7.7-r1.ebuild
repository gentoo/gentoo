# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Audio file volume normalizer"
HOMEPAGE="http://normalize.nongnu.org/"
SRC_URI="
	https://savannah.nongnu.org/download/${PN}/${P}.tar.bz2
	https://dev.gentoo.org/~radhermit/distfiles/${P}-m4.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="audiofile mad nls"

RDEPEND="
	audiofile? ( media-libs/audiofile:= )
	mad? ( media-libs/libmad:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

PATCHES=(
	"${FILESDIR}"/${P}-audiofile-pkgconfig.patch
	"${WORKDIR}"/${P}-m4.patch
)

src_prepare() {
	default
	AT_M4DIR="." eautoreconf
}

src_configure() {
	econf \
		$(use_with audiofile) \
		$(use_with mad) \
		$(use_enable nls) \
		--disable-xmms
}
