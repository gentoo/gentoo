# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 multilib-minimal

# Upstream call this release 3.480, but drop the 0 in the tarball filename
MY_PV="3.48"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/${MY_P}.tar.gz"

LICENSE="ISC"
SLOT="0/8"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="bzip2 cpu_flags_x86_sse2 cpu_flags_x86_ssse3 curl"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	net-misc/curl[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	dev-lang/cfortran
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	default

	# Avoid internal cfortran
	mv cfortran.h cfortran.h.disabled
	ln -s "${EPREFIX}"/usr/include/cfortran.h . || die

	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_with bzip2) \
		$(use_enable curl) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_ssse3 ssse3)
}

multilib_src_install_all() {
	dodoc README docs/changes.txt

	dodoc docs/{quick,cfitsio,fpackguide}.pdf
	dodoc docs/fitsio.pdf

	insinto /usr/share/doc/${PF}/examples
	doins cookbook.c testprog.c speed.c smem.c
	doins cookbook.f testf77.f

	# Remove static libs
	find "${ED}" -name '*.a' -delete || die
}
