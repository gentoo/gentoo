# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Secret Rabbit Code (aka libsamplerate) is a Sample Rate Converter for audio"
HOMEPAGE="http://www.mega-nerd.com/SRC/"

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/erikd/libsamplerate.git"
else
	SRC_URI="http://www.mega-nerd.com/SRC/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

# Alsa/FFTW are only required for tests
# libsndfile is only used by examples and tests
DEPEND="
	test? (
		media-libs/alsa-lib[${MULTILIB_USEDEP}]
		media-libs/libsndfile[${MULTILIB_USEDEP}]
		sci-libs/fftw:3.0[${MULTILIB_USEDEP}]
	)
	virtual/pkgconfig"

src_prepare() {
	default

	[[ ${PV} == *9999 ]] && eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable test alsa) \
		$(use_enable test fftw) \
		$(use_enable test sndfile)
}

multilib_src_install_all() {
	einstalldocs

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
