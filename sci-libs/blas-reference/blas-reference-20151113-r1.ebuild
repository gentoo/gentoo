# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR=emake

inherit eutils fortran-2 cmake-utils multilib flag-o-matic toolchain-funcs

LPN=lapack
LPV=3.6.0

DESCRIPTION="Basic Linear Algebra Subprograms F77 reference implementations"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/${LPN}/${LPN}-${LPV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc"

RDEPEND="
	app-eselect/eselect-blas
	doc? ( app-doc/blas-docs )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${LPN}-${LPV}"
PATCHES=( "${FILESDIR}/lapack-reference-${LPV}-fix-build-system.patch" )

src_prepare() {
	cmake-utils_src_prepare

	ESELECT_PROF=reference

	cp "${FILESDIR}"/eselect.blas.reference-r1 "${T}"/eselect.blas.reference || die
	sed -i -e "s:/usr:${EPREFIX}/usr:" "${T}"/eselect.blas.reference || die
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/\.so\([\.0-9]\+\)\?/\1.dylib/g' \
			"${T}"/eselect.blas.reference || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DUSE_OPTIMIZED_BLAS=OFF
		-DCMAKE_Fortran_FLAGS="$(get_abi_CFLAGS) ${FCFLAGS}"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -C BLAS
}

src_test() {
	local BUILD_DIR="${WORKDIR}/${P}_build/BLAS"
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install -C BLAS

	mkdir -p "${ED}/usr/$(get_libdir)/blas/reference" || die
	mv "${ED}/usr/$(get_libdir)"/lib* "${ED}/usr/$(get_libdir)/pkgconfig"/* \
		"${ED}/usr/$(get_libdir)/blas/reference" || die
	rmdir "${ED}/usr/$(get_libdir)/pkgconfig" || die

	eselect blas add $(get_libdir) "${T}"/eselect.blas.reference ${ESELECT_PROF}
}

pkg_postinst() {
	local p=blas
	local current_lib=$(eselect ${p} show | cut -d' ' -f2)
	if [[ ${current_lib} == ${ESELECT_PROF} || -z ${current_lib} ]]; then
		# work around eselect bug #189942
		local configfile="${EROOT}"/etc/env.d/${p}/$(get_libdir)/config
		[[ -e ${configfile} ]] && rm -f ${configfile}
		eselect ${p} set ${ESELECT_PROF}
		elog "${p} has been eselected to ${ESELECT_PROF}"
	else
		elog "Current eselected ${p} is ${current_lib}"
		elog "To use ${p} ${ESELECT_PROF} implementation, you have to issue (as root):"
		elog "\t eselect ${p} set ${ESELECT_PROF}"
	fi
}
