# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/nfft/nfft-3.2.3.ebuild,v 1.2 2015/01/04 16:32:28 ottxor Exp $

EAPI="5"

inherit autotools-utils toolchain-funcs

DESCRIPTION="library for nonequispaced discrete Fourier transformations"
HOMEPAGE="http://www-user.tu-chemnitz.de/~potts/nfft"
SRC_URI="http://www-user.tu-chemnitz.de/~potts/nfft/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="openmp static-libs"

RDEPEND="sci-libs/fftw:3.0[threads,openmp?]"
DEPEND="${RDEPEND}"

pkg_pretend() {
	use openmp && ! tc-has-openmp && \
		die "Please switch to an openmp compatible compiler"
}

src_configure() {
	local myeconfargs=(
	    --enable-all
		$(use_enable openmp)
	)
	autotools-utils_src_configure
}
