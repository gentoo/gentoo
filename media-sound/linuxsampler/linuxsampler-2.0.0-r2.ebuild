# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc jack lv2 sqlite static-libs"

RDEPEND="sqlite? ( >=dev-db/sqlite-3.3 )
	>=media-libs/libgig-4.0.0
	media-libs/alsa-lib
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	lv2? ( media-libs/lv2 )"
PATCHES=(
	"${FILESDIR}/${P}-nptl-hardened.patch"
	"${FILESDIR}/${P}-lv2-automagic.patch"
)

src_prepare() {
	default
	# Force regeneration of the file to let it build with all bison
	# versions, bug #556204
	rm src/network/lscpparser.cpp || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-alsa-driver \
		--disable-arts-driver \
		$(use_enable jack jack-driver) \
		$(use_enable lv2) \
		$(use_enable sqlite instruments-db) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	default
	use doc && dodoc -r doc/html
	prune_libtool_files
}
