# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Reverb and Impulse Response Convolution plug-ins (Audacious/JACK)"
HOMEPAGE="https://savannah.nongnu.org/projects/freeverb3"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="forcefpu openmp plugdouble threads"

RDEPEND="sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-pc-file.patch  # bug 889436
)

src_configure() {
	local myeconfargs=(
		--enable-release
		--enable-undenormal
		--disable-autocflags
		--disable-pluginit
		--disable-profile
		--disable-sample
		--disable-srcnewcoeffs
		--disable-audacious
		--disable-jack
		$(use_enable openmp omp)
		$(use_enable plugdouble)
		$(use_enable threads pthread)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs

	insinto /usr/share/${PN}/samples/IR
	doins samples/IR/*.wav

	find "${D}" -name '*.la' -delete || die  # bug 847403
}
