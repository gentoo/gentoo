# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran

inherit fortran-2 toolchain-funcs

LAPACKPV=3.12.0

DESCRIPTION="Automatically Tuned Linear Algebra Software"
HOMEPAGE="https://math-atlas.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/math-atlas/${PN}${PV}.tar.bz2
	fortran? ( lapack? (
		https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v${LAPACKPV}.tar.gz
		-> lapack-${LAPACKPV}.tar.gz
	) )
"
S="${WORKDIR}/ATLAS"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran generic lapack static-libs threads"

PATCHES=(
	"${FILESDIR}/${PN}-3.10.2-x32-support.patch"
	"${FILESDIR}/${PN}-3.10.2-format-security.patch"
	"${FILESDIR}/${PN}-3.10.3-fix-ancient-c.patch"
)

pkg_setup() {
	local _cpufreq
	for _cpufreq in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
		if [[ -f ${_cpufreq} ]]; then
			if ! grep -q performance "${_cpufreq}"; then
				echo 2> /dev/null performance > "${_cpufreq}" || \
					die "${PN} needs all cpu set to performance"
			fi
		fi
	done
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	# hack needed to trick the flaky gcc detection
	local mycc
	mycc="$(type -P "$(tc-getCC)")"
	[[ ${mycc} == *gcc* ]] && mycc=gcc
	atlas_configure() {
		local myconf=(
			--cripple-atlas-performance
			--prefix="/usr"
			--libdir="/usr/$(get_libdir)"
			--incdir="/usr/include"
			--cc="$(tc-getCC)"
			"-D c -DWALL"
			"-C acg '${mycc}'"
			"-F acg '${CFLAGS}'"
			"-Ss pmake '\$(MAKE) ${MAKEOPTS}'"
		)

		# OpenMP shown to decreased performance over POSIX threads
		# (at least in 3.9.x, see atlas-dev mailing list)
		if use threads; then
			if use generic; then # 2 threads is most generic
				myconf+=( "-t 2" "-Si omp 0" )
			else
				myconf+=( "-t -1" "-Si omp 0" )
			fi
		else
			myconf+=( "-t  0" "-Si omp 0" )
		fi

		if use amd64 || use ppc64 || use sparc; then
			if [[ ${ABI} = amd64 ]] || [[ ${ABI} = ppc64 ]] || [[ ${ABI} = sparc64 ]] ; then
				myconf+=( "-b 64" )
			elif [[ ${ABI} = x86 ]] || [[ ${ABI} = ppc ]] || [[ ${ABI} = sparc32 ]] ; then
				myconf+=( "-b 32" )
			elif [[ ${ABI} = x32 ]] ; then
				myconf+=( "-b 48" )
			else
				myconf+=( "-b 64" )
			fi
		elif use ppc || use x86; then
			myconf+=( "-b 32" )
		fi
		if use fortran; then
			myconf+=(
				"-C if '$(type -P "$(tc-getFC)")'"
				"-F if '${FFLAGS}'"
			)
			if use lapack; then
				myconf+=(
					"-Si latune 1"
					"--with-netlib-lapack-tarfile=${DISTDIR}/lapack-${LAPACKPV}.tar.gz"
				)
			else
				myconf+=( "-Si latune 0" )
			fi
		else
			myconf+=( "-Si latune 0" "--nof77" )
		fi
		# generic stuff found by make make xprint_enums in atlas build dir
		# basically assuming sse2+sse1 and 2 threads max
		use generic && use x86   && myconf+=( "-V 384 -A 13")
		use generic && use amd64 && myconf+=( "-V 384 -A 24")

		local confdir="${S}_${1}"; shift
		myconf+=( $@ )
		mkdir "${confdir}" || die
		cd "${confdir}" || die
		# for debugging
		echo "${myconf[@]}" > myconf.out
		"${S}"/configure ${myconf[@]} || die "configure in ${confdir} failed"
	}

	atlas_configure shared "-Fa alg -fPIC" ${EXTRA_ECONF}
	use static-libs && atlas_configure static ${EXTRA_ECONF}
}

src_compile() {
	atlas_compile() {
		pushd "${S}_${1}" > /dev/null || die
		# atlas does its own parallel builds
		emake -j1 build
		cd lib || die
		emake libclapack.a
		[[ -e libptcblas.a ]] && emake libptclapack.a
		popd > /dev/null || die
	}

	atlas_compile shared
	use static-libs && atlas_compile static
}

src_test() {
	cd "${S}_shared" || die
	emake -j1 check time
}

# transform a static archive into a shared library and install them
# atlas_install_libs <mylib.a> [extra link flags]
atlas_install_libs() {
	local libname soname
	libname=$(basename "${1%.*}")
	einfo "Installing ${libname}"
	soname=${libname}.so.$(ver_cut 1)
	shift
	pushd "${S}_shared"/lib > /dev/null || die
	${LINK:-$(tc-getCC)} ${LDFLAGS} -shared "-Wl,-soname=${soname}" \
		-Wl,--whole-archive "${libname}.a" -Wl,--no-whole-archive \
		$@ -o "${soname}" || die "Creating ${soname} failed"
	dolib.so "${soname}"
	ln -s "${soname}" "${soname%.*}"
	dosym "${soname}" "/usr/$(get_libdir)/${soname%.*}"
	popd > /dev/null || die
	use static-libs && dolib.a "${S}_static/lib/${libname}.a"
}

src_install() {
	cd "${S}_shared/lib" || die
	# rename to avoid collision with other packages
	local l
	for l in {,c}{blas,lapack}; do
		if [[ -e lib${l}.a ]]; then
			mv lib{,atl}"${l}.a"
			use static-libs && mv "${S}"_static/lib/lib{,atl}"${l}.a"
		fi
	done

	[[ -e libptcblas.a ]] && PTLIBS="-lpthread"

	# atlas
	atlas_install_libs libatlas.a -lm "${PTLIBS}"

	# cblas
	atlas_install_libs libatlcblas.a -lm -L. -latlas

	# cblas threaded
	[[ -e libptcblas.a ]] && \
		atlas_install_libs libptcblas.a -lm -L. -latlas "${PTLIBS}"

	if use lapack; then
		# clapack
		atlas_install_libs libatlclapack.a -lm -L. -latlas -latlcblas

		# clapack threaded
		[[ -e libptclapack.a ]] && \
			atlas_install_libs libptclapack.a -lm -L. -latlas -lptcblas "${PTLIBS}"
	fi

	if use fortran; then
		LINK=$(tc-getF77)

		# blas
		atlas_install_libs libf77blas.a -lm -L. -latlas

		# blas threaded
		[[ -e libptf77blas.a ]] && \
			atlas_install_libs libptf77blas.a -lm -L. -latlas "${PTLIBS}"

		if use lapack; then
			# lapack
			atlas_install_libs libatllapack.a \
				-lm -L. -latlas -latlcblas -lf77blas
			# lapack threaded
			[[ -e libptlapack.a ]] && \
				atlas_install_libs libptlapack.a -lm -L. -latlas -lptcblas -lptf77blas "${PTLIBS}"
		fi
	fi

	cd "${S}" || die
	insinto "/usr/include/${PN}"
	doins include/*.h

	cd "${S}/doc" || die
	dodoc INDEX.txt AtlasCredits.txt ChangeLog
	use doc && dodoc atlas*pdf cblas.pdf cblasqref.pdf
	use doc && use fortran && dodoc f77blas*pdf
	use doc && use fortran && use lapack && dodoc -- *lapack*pdf
}
