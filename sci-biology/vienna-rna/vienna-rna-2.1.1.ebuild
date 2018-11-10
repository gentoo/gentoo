# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=true
AUTOTOOLS_AUTORECONF=true
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils distutils-r1 multilib perl-module toolchain-funcs

DESCRIPTION="RNA secondary structure prediction and comparison"
HOMEPAGE="http://www.tbi.univie.ac.at/~ivo/RNA/"
SRC_URI="http://www.tbi.univie.ac.at/~ronny/RNA/ViennaRNA-${PV}.tar.gz"

SLOT="0"
LICENSE="vienna-rna"
KEYWORDS="amd64 ppc x86"
IUSE="doc openmp python static-libs"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-lang/perl
	media-libs/gd
	doc? ( dev-texlive/texlive-latex )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig:0 )"

S="${WORKDIR}/ViennaRNA-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-bindir.patch
	"${FILESDIR}"/${P}-prll.patch
	"${FILESDIR}"/${P}-impl-decl.patch
)

src_prepare() {
	sed -i 's/ getline/ v_getline/' Readseq/ureadseq.c || die
	sed -i 's/@PerlCmd@ Makefile.PL/& INSTALLDIRS=vendor/' Perl/Makefile.am || die

	autotools-utils_src_prepare

	if use python; then
		cp "${FILESDIR}"/${P}-setup.py "${S}"/setup.py || die
		PATCHES=()
		distutils-r1_src_prepare
	fi
}

src_configure() {
	local myeconfargs=(
		--with-cluster
		$(use_enable openmp) )

	use doc || \
		myeconfargs+=(
			--without-doc-pdf
			--without-doc-html
			--without-doc
			)
	autotools-utils_src_configure
	sed \
		-e "s:LIBDIR = /usr/lib:LIBDIR = ${D}/usr/$(get_libdir):" \
		-e "s:INCDIR = /usr/include:INCDIR = ${D}/usr/include:" \
		-i RNAforester/g2-0.70/Makefile || die
	sed \
		-e "s:CC=gcc:CC=$(tc-getCC):" \
		-e "s:^CFLAGS=:CFLAGS=${CFLAGS}:" \
		-i Readseq/Makefile || die
	use python && distutils-r1_src_configure
}

src_compile() {
	autotools-utils_src_compile
	autotools-utils_src_compile -C Readseq build CC=$(tc-getCC)

	# TODO: Add (optional?) support for the NCBI toolkit.
	if use python; then
		pushd Perl > /dev/null
			mv RNA_wrap.c{,-perl} || die
			swig -python RNA.i || die
		popd > /dev/null
		distutils-r1_src_compile
		mv Perl/RNA_wrap.c{-perl,} || die
	fi
}

src_test() {
	autotools-utils_src_compile -C Perl check
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
	use python && distutils-r1_src_install
}
