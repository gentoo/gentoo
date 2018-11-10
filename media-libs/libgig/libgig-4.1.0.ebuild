# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ library for loading Gigasampler and DLS level 1/2 files"
HOMEPAGE="https://www.linuxsampler.org/libgig/"
SRC_URI="https://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc"

RDEPEND="
	media-libs/audiofile
	media-libs/libsndfile"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_compile() {
	emake
	use doc && emake docs
}

src_install() {
	emake DESTDIR="${D}" install

	use doc && HTML_DOCS=( doc/html/. )
	einstalldocs

	# For libgig.so to be found at runtime
	printf "LDPATH=\"${EPREFIX}/usr/$(get_libdir)/libgig/\"" > 99${PN}
	doenvd "99${PN}"
}
