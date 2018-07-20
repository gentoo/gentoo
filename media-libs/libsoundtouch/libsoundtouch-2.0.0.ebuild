# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic ltprune multilib-minimal

MY_PN="${PN/lib}"

DESCRIPTION="Audio processing library for changing tempo, pitch and playback rates"
HOMEPAGE="https://www.surina.net/soundtouch/"
SRC_URI="https://www.surina.net/soundtouch/${P/lib}.tar.gz"

LICENSE="LGPL-2.1"
# subslot = libSoundTouch.so soname
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="cpu_flags_x86_sse openmp static-libs"

DEPEND=">=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	default
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
	sed -i "s:^\(dist_doc_DATA=\)COPYING.TXT :\1:" Makefile.am || die
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g' configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		--disable-integer-samples
		$(use_enable cpu_flags_x86_sse x86-optimizations)
		$(use_enable openmp)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

multilib_src_install() {
	emake DESTDIR="${D}" pkgdocdir="${EPREFIX}"/usr/share/doc/${PF}/html install
}

multilib_src_install_all() {
	prune_libtool_files
}
