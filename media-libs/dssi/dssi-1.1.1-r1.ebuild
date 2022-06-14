# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Plugin API for software instruments with user interfaces"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/liblo-0.12
	virtual/jack
	>=media-libs/ladspa-sdk-1.12-r2
	>=media-libs/libsndfile-1.0.11
	>=media-libs/libsamplerate-0.1.1-r1"
DEPEND="${RDEPEND}
	sys-apps/sed
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-no-werror.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:libdir=.*:libdir=@libdir@:' \
		dssi.pc.in || die

	sed -i -e '/PKG_CHECK_MODULES(QT/s:QtGui:dIsAbLe&:' configure.ac || die

	eautoreconf
}

src_install() {
	DOCS=( README doc/TODO doc/*.txt )
	default
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}
