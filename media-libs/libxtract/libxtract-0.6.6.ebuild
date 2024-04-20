# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple, portable, lightweight library of audio feature extraction functions"
HOMEPAGE="https://github.com/jamiebullock/LibXtract"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE="doc fftw"

RDEPEND="fftw? ( sci-libs/fftw:3.0 )"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen[dot] )"

src_configure() {
	econf \
		$(use_enable fftw fft)
	# Prevent doc from being generated automagically
	if ! use doc; then
		touch doc/doxygen-build.stamp || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -name "*.la" -delete || die
	dodoc README.md TODO AUTHORS
	use doc && dodoc -r doc/html/.
}
