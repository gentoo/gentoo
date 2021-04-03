# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit epatch

DESCRIPTION="Tiny Vector Matrix library using Expression Templates"
HOMEPAGE="http://tvmet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc test"
RESTRICT="!test? ( test )"

DEPEND="doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )"

src_prepare() {
	epatch "${FILESDIR}/${P}-respect-cxxflags.patch"

	sed -i \
		-e 's|^GENERATE_LATEX.*|GENERATE_LATEX = NO|' \
		doc/Doxyfile.in || die "sed failed"

	# Doc installation is broken with newer Doxygen and autoconf <=2.61
	# and we can't rerun autoconf without requiring cppunit unconditionally
	sed -i \
		-e '/^SUBDIRS/ s|doc ||' \
		Makefile.in || die "sed failed"
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable doc docs) \
		$(use_enable test cppunit)
}

src_compile() {
	default
	if use doc ; then
		cd doc
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	default
	use doc && dohtml -r doc/html/*
}
