# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 multilib-minimal

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/10"
KEYWORDS="~alpha amd64 ~hppa ~ppc ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="bzip2 curl threads tools cpu_flags_x86_sse2 cpu_flags_x86_ssse3"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
"
# Bug #803350
DEPEND="${RDEPEND}
	<dev-lang/cfortran-20110621
"

PATCHES=(
	"${FILESDIR}/${PN}-3.490-ldflags.patch"
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
		$(use_enable threads reentrant)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_ssse3 ssse3)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default

	if use tools ; then
		emake utils
	fi
}

multilib_src_install_all() {
	dodoc README docs/changes.txt

	dodoc docs/{quick,cfitsio,fpackguide}.pdf
	dodoc docs/fitsio.pdf

	docinto examples
	dodoc cookbook.c testprog.c speed.c smem.c
	dodoc cookbook.f testf77.f

	# https://bugs.gentoo.org/855191
	if use tools; then
		rm "${ED}/usr/bin/smem" || die
	fi

	# Remove static libs
	find "${ED}" -name '*.a' -delete || die
}
