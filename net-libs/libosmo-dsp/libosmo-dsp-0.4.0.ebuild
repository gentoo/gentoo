# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A library with SDR DSP primitives"
HOMEPAGE="http://git.osmocom.org/libosmo-dsp/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.osmocom.org/${PN}"
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="doc static-libs"

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latexextra
	)
	virtual/pkgconfig
"

# Adapt version for libosmodsp.pc to 0.4.0 snapshot (bug #857678)
# Needs to be adapted on version bump.
PATCHES=( "${FILESDIR}/${P}-version.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use doc || export ac_cv_path_DOXYGEN=false
	default_src_configure
}

src_install() {
	default_src_install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libosmodsp.a
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libosmodsp.la
}
