# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library for porting blocked I/O OSS/ALSA audio applications to JACK"
HOMEPAGE="https://bio2jack.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/bio2jack/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 ~riscv ~sparc x86"
IUSE="static-libs"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	media-libs/libsamplerate
	virtual/jack"
RDEPEND="${DEPEND}"

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
