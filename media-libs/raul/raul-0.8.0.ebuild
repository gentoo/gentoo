# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit waf-utils python eutils

DESCRIPTION="C++ utility library primarily aimed at audio/musical applications"
HOMEPAGE="http://wiki.drobilla.net/Raul"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc test"

RDEPEND="dev-libs/boost
	>=dev-libs/glib-2.14.0"
DEPEND="${RDEPEND}
	=dev-lang/python-2*
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

RAUL_TESTS="atomic_test atom_test list_test midi_ringbuffer_test path_test quantize_test queue_test ringbuffer_test smf_test table_test thread_test time_test"
DOCS=( AUTHORS README ChangeLog )

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}/ldconfig2.patch"
	epatch "${FILESDIR}/${P}-gcc47.patch"
}

src_configure() {
	waf-utils_src_configure \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use debug && echo "--debug") \
		$(use doc && echo "--docs") \
		$(use test && echo "--test")
}

src_test() {
	cd "${S}/build/test" || die
	for i in ${RAUL_TESTS} ; do
		einfo "Running test ${i}"
		LD_LIBRARY_PATH=.. ./${i} || die
	done
}
