# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=true
AUTOTOOLS_AUTORECONF=true
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils distutils-r1 multilib perl-module toolchain-funcs

DESCRIPTION="RNA secondary structure prediction and comparison"
HOMEPAGE="http://www.tbi.univie.ac.at/~ivo/RNA/"
SRC_URI="http://www.tbi.univie.ac.at/RNA/packages/source/ViennaRNA-${PV}.tar.gz"

SLOT="0"
LICENSE="vienna-rna"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc openmp python static-libs"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-lang/perl
	media-libs/gd
	doc? ( dev-texlive/texlive-latex )
	python? (
		${PYTHON_DEPS}
		dev-lang/swig:0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ViennaRNA-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-bindir.patch
	"${FILESDIR}"/${PN}-2.1.1-prll.patch
	"${FILESDIR}"/${PN}-2.1.1-impl-decl.patch
)

src_prepare() {
	sed -i 's/ getline/ v_getline/' Readseq/ureadseq.c || die
	sed -i 's/@PerlCmd@ Makefile.PL/& INSTALLDIRS=vendor/' interfaces/Perl/Makefile.am || die

	autotools-utils_src_prepare

	if use python; then
		cd interfaces/Python || die
		local PATCHES=()
		distutils-r1_src_prepare
	fi
}

src_configure() {
	local myeconfargs=(
		--with-cluster
		$(use_enable openmp)
	)

	use doc || \
		myeconfargs+=(
			--without-doc-pdf
			--without-doc-html
			--without-doc
			)
	autotools-utils_src_configure
	sed \
		-e "s:CC=gcc:CC=$(tc-getCC):" \
		-e "s:^CFLAGS=:CFLAGS=${CFLAGS}:" \
		-i Readseq/Makefile || die
	if use python; then
		cd interfaces/Python || die
		distutils-r1_src_configure
	fi
}

src_compile() {
	autotools-utils_src_compile
	autotools-utils_src_compile -C Readseq build CC=$(tc-getCC)

	# TODO: Add (optional?) support for the NCBI toolkit.
	if use python; then
		cd interfaces/Python || die
		emake RNA_wrap.c
		distutils-r1_src_compile
	fi
}

src_test() {
	autotools-utils_src_compile -C interfaces/Perl check
	use python && autotools-utils_src_compile -C interfaces/Python check
	autotools-utils_src_compile -C Readseq test
}

src_install() {
	autotools-utils_src_install

	if ! use static-libs; then
		rm -f "${ED}"/usr/$(get_libdir)/*.a || die
	fi

	newbin Readseq/readseq readseq-vienna
	dodoc Readseq/Readseq.help
	newdoc Readseq/Readme README.readseq
	newdoc Readseq/Formats Formats.readseq

	# remove perlocal.pod to avoid file collisions (see #240358)
	perl_delete_localpod || die "Failed to remove perlocal.pod"
	if use python; then
		cd interfaces/Python || die
		distutils-r1_src_install
	fi
}
