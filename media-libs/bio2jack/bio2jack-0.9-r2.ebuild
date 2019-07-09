# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A library for porting blocked I/O OSS/ALSA audio applications to JACK"
HOMEPAGE="http://bio2jack.sourceforge.net/"
SRC_URI="mirror://sourceforge/bio2jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static-libs"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	media-libs/libsamplerate
	virtual/jack"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	# upstream does not provide a real release, it releases a tarball
	# with a _prebuilt_ copy of bio2jack. Drop all of the built stuff
	# and recreate autotools from scratch, then build.
	rm -r *.o *.la *.lo .libs .deps Makefile config.{log,status} stamp-h1 || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default
	dobin bio2jack-config
	rm -f "${ED}"/usr/lib*/lib*.la || die
}
