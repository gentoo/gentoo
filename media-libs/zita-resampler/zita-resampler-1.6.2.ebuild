# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/1"
KEYWORDS="amd64"
IUSE="tools"

RDEPEND="tools? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}"
BDEPEND=""

HTML_DOCS="docs/."

PATCHES=( "${FILESDIR}"/${PN}-1.6.2-makefile.patch )

src_compile() {
	tc-export CXX

	emake -C source
	if use tools; then
		emake -C apps
	fi
}

src_install() {
	emake -C source DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}"/usr/$(get_libdir) install
	if use tools; then
		emake -C apps DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	fi

	einstalldocs
}
