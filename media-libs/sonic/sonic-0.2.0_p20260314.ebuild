# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

COMMIT_HASH="b93885dcb70aae50c6f76b0fe4e0868f029a077e"
DESCRIPTION="Simple library to speed up or slow down speech"
HOMEPAGE="https://github.com/waywardgeek/sonic"
SRC_URI="https://github.com/waywardgeek/sonic/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="Apache-2.0"
SONAME="0.3.0" # follow LIB_TAG in Makefile
SLOT="0/${SONAME}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="fftw test"
RESTRICT="!test? ( test )"

DEPEND="fftw? ( sci-libs/fftw:= )"
RDEPEND="${DEPEND}"

src_compile() {
	local myemakeargs=(
		AR=$(tc-getAR)
		CC=$(tc-getCC)
		CFLAGS="${CFLAGS} -fPIC -pthread"
	)

	use fftw && myemakeargs+=(
		USE_SPECTROGRAM=1
		FFTLIB=$($(tc-getPKG_CONFIG) --libs fftw3)
	)

	emake "${myemakeargs[@]}" all $(usev test sonic_unit_test)
}

src_test() {
	emake test
}

src_install() {
	local myemakeargs=(
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		DESTDIR="${D}"
	)
	emake "${myemakeargs[@]}" install

	einstalldocs
	doman sonic.1

	find "${ED}" -type f -name '*.a' -delete || die
}
