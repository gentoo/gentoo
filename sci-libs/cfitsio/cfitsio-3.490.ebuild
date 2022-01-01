# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-${PV%0*}"
inherit fortran-2 multilib-minimal

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
SLOT="0/9"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="bzip2 curl cpu_flags_x86_sse2 cpu_flags_x86_ssse3"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-lang/cfortran
"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-system-zlib.patch"
	"${FILESDIR}/${P}-pkgconfig.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	default

	# Avoid internal cfortran
	mv cfortran.h cfortran.h.disabled || die
	ln -s "${EPREFIX}"/usr/include/cfortran.h . || die

	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_with bzip2)
		$(use_enable curl)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_ssse3 ssse3)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	dodoc README docs/changes.txt

	dodoc docs/{quick,cfitsio,fpackguide}.pdf
	dodoc docs/fitsio.pdf

	docinto examples
	dodoc cookbook.c testprog.c speed.c smem.c
	dodoc cookbook.f testf77.f

	# Remove static libs
	find "${ED}" -name '*.a' -delete || die
}
