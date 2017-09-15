# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools python-r1 toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-lang/perl
	=sci-libs/htslib-${PV}*
	sys-libs/ncurses:0=
	sys-libs/zlib
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-1.5-buildsystem.patch" )

src_prepare() {
	default

	python_setup
	python_fix_shebang misc/varfilter.py

	# remove bundled htslib
	rm -r htslib-* || die

	eautoreconf
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}"
	default
}

src_install() {
	default

	# install libbam and headers
	dolib.so libbam.so*

	insinto /usr/include/bam
	doins *.h

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
