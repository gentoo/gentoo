# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR=emake

inherit eutils fortran-2 cmake-utils multilib flag-o-matic toolchain-funcs

LPN=lapack
LPV=3.6.0

DESCRIPTION="C wrapper interface to the F77 reference BLAS implementation"
HOMEPAGE="http://www.netlib.org/cblas/"
SRC_URI="http://www.netlib.org/${LPN}/${LPN}-${LPV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="app-eselect/eselect-cblas
	>=virtual/blas-3.6
	virtual/pkgconfig"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${LPN}-${LPV}"
PATCHES=( "${FILESDIR}/lapack-reference-${LPV}-fix-build-system.patch" )

src_prepare() {
	cmake-utils_src_prepare

	ESELECT_PROF=reference

	cp "${FILESDIR}"/eselect.cblas.reference-r2 "${T}"/eselect.cblas.reference || die
	sed -i -e "s:/usr:${EPREFIX}/usr:" "${T}"/eselect.cblas.reference || die
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/\.so\([\.0-9]\+\)\?/\1.dylib/g' \
			"${T}"/eselect.cblas.reference || die
	fi

	sed -i \
		-e 's:/CMAKE/:/cmake/:g' \
		CBLAS/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DCBLAS=ON
		-DUSE_OPTIMIZED_BLAS=ON
		-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
		-DCMAKE_C_FLAGS="$($(tc-getPKG_CONFIG) --cflags blas) ${CFLAGS}"
		-DCMAKE_Fortran_FLAGS="$($(tc-getPKG_CONFIG) --cflags blas) $(get_abi_CFLAGS) ${FCFLAGS}"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -C CBLAS
}

src_install() {
	cmake-utils_src_install -C CBLAS

	mkdir -p "${ED}/usr/$(get_libdir)/blas/reference" || die
	mv "${ED}/usr/$(get_libdir)"/lib* "${ED}/usr/include"/cblas* \
		"${ED}/usr/$(get_libdir)/pkgconfig"/* \
		"${ED}/usr/$(get_libdir)/blas/reference" || die

	rmdir "${ED}/usr/$(get_libdir)/pkgconfig" || die
	rmdir "${ED}/usr/include" || die

	eselect cblas add $(get_libdir) "${T}"/eselect.cblas.reference ${ESELECT_PROF}
}

pkg_postinst() {
	local p=cblas
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
