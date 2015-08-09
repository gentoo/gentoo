# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

MY_P="${PN}_v${PV/./_}"

DESCRIPTION="Probabilistic Consistency-based Multiple Alignment of Amino Acid Sequences"
HOMEPAGE="http://probcons.stanford.edu/"
SRC_URI="http://probcons.stanford.edu/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

# Gnuplot is explicitly runtime-only, it's run using system()
RDEPEND="
	!sci-geosciences/gmt
	sci-visualization/gnuplot"
DEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-cxxflags.patch \
		"${FILESDIR}"/gcc-4.3.patch \
		"${FILESDIR}"/${P}-gcc-4.6.patch
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		OPT_CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dobin probcons project makegnuplot
	# Overlap with imagemagick
	newbin compare compare-probcons
	dodoc README
}

pkg_postinst() {
	ewarn "The 'compare' binary is installed as 'compare-probcons'"
	ewarn "to avoid overlap with other packages."
	einfo "You may also want to download the user manual"
	einfo "from http://probcons.stanford.edu/manual.pdf"
}
