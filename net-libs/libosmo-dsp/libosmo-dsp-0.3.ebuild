# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools multilib

DESCRIPTION="A library with SDR DSP primitives"
HOMEPAGE="http://git.osmocom.org/libosmo-dsp/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.osmocom.org/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="doc static-libs"

RDEPEND="sci-libs/fftw"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	use doc || export ac_cv_path_DOXYGEN=false
	default_src_configure
}

src_install() {
	default_src_install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libosmodsp.a
}
