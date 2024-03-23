# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools subversion

DESCRIPTION="C++ library for loading Gigasampler and DLS level 1/2 files"
HOMEPAGE="https://www.linuxsampler.org/libgig/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/libgig/trunk"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND="
	media-libs/audiofile
	media-libs/libsndfile"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )"

src_prepare() {
	default

	emake -f Makefile.svn
	eautoreconf
}

src_compile() {
	emake
	use doc && emake docs
}

src_install() {
	emake DESTDIR="${D}" install

	use doc && HTML_DOCS=( doc/html/. )
	einstalldocs

	find "${ED}" -name '*.la' -type f -delete || die

	# For libgig.so to be found at runtime
	printf "LDPATH=\"${EPREFIX}/usr/$(get_libdir)/libgig/\"" > 99${PN} || die
	doenvd "99${PN}"
}
