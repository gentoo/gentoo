# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C++ library implementing a real-time convolution matrix"
HOMEPAGE="https://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0/4"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

RDEPEND="sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-4.0.3-makefile.patch )

src_compile() {
	emake -C source CXX="$(tc-getCXX)"
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)
	emake -C source "${myemakeargs[@]}" install

	einstalldocs
}
