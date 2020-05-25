# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_ECLASS=cmake
inherit flag-o-matic multibuild cmake-multilib

if [[ ${PV} = 9999* ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/multicoreware/x265"
else
	SRC_URI="https://bitbucket.org/multicoreware/x265/downloads/${PN}_${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Library for encoding video streams into the H.265/HEVC format"
HOMEPAGE="http://x265.org/ https://bitbucket.org/multicoreware/x265/wiki/Home"

LICENSE="GPL-2"
# subslot = libx265 soname
SLOT="0/188"
IUSE="+asm +10bit +12bit cpu_flags_arm_neon cpu_flags_ppc_altivec numa power8 test"

# Test suite requires assembly support and is known to be broken
RESTRICT="test"

ASM_DEPEND=">=dev-lang/nasm-2.13"

BDEPEND="asm? (
		abi_x86_32? ( ${ASM_DEPEND} )
		abi_x86_64? ( ${ASM_DEPEND} )
	)"

RDEPEND="numa? ( >=sys-process/numactl-2.0.10-r1[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3-arm.patch
	"${FILESDIR}"/${PN}-3.3-neon.patch
	"${FILESDIR}"/${PN}-3.3-ppc64.patch
)

src_unpack() {
	if [[ ${PV} = 9999* ]] ; then
		mercurial_src_unpack
		# Can't set it at global scope due to mercurial.eclass limitations...
		export S=${WORKDIR}/${P}/source
	else
		unpack ${A}
		export S="$(echo "${WORKDIR}/${PN}_"*"/source")"
	fi
}

# By default, the library and the encoder is configured for only one output bit
# depth. Meaning, one has to rebuild libx265 if (s)he wants to produce HEVC
# files with a different bit depth, which is annoying. However, upstream
# supports proper namespacing for 8bits, 10bits & 12bits HEVC and linking all
# that together so that the resulting library can produce all three of them
# instead of only one.
# The API requires the bit depth parameter, so that libx265 can then chose which
# variant of the encoder to use.
# To achieve this, we have to build one (static) library for each non-main
# variant, and link it into the main library.
# Upstream documents using the 8bit variant as main library, hence we do not
# allow disabling it: "main" *MUST* come last in the following list.

x265_get_variants() {
	local -a variants=()
	use 12bit && variants+=( main12 )
	use 10bit && variants+=( main10 )
	variants+=( main )
	echo "${variants[@]}"
}

x265_variant_src_configure() {
	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die

	local mycmakeargs=( "${myabicmakeargs[@]}" )
	case "${MULTIBUILD_VARIANT}" in
		"main12")
			mycmakeargs+=(
				-DHIGH_BIT_DEPTH=ON
				-DEXPORT_C_API=OFF
				-DENABLE_SHARED=OFF
				-DENABLE_CLI=OFF
				-DMAIN12=ON
			)
			# disable altivec for 12bit build #607802#c5
			[[ ${ABI} = ppc* ]] && mycmakeargs+=( -DENABLE_ALTIVEC=OFF )
			;;
		"main10")
			mycmakeargs+=(
				-DHIGH_BIT_DEPTH=ON
				-DEXPORT_C_API=OFF
				-DENABLE_SHARED=OFF
				-DENABLE_CLI=OFF
			)
			# disable altivec for 10bit build #607802#c5
			[[ ${ABI} = ppc* ]] && mycmakeargs+=( -DENABLE_ALTIVEC=OFF )
			;;
		"main")
			if (( "${#MULTIBUILD_VARIANTS[@]}" > 1 )) ; then
				local myvariants=( "${MULTIBUILD_VARIANTS[@]}" )
				unset myvariants[${#MULTIBUILD_VARIANTS[@]}-1]
				local liblist="" v=
				for v in "${myvariants[@]}" ; do
					ln -s "${BUILD_DIR%-*}-${v}/libx265.a" "libx265_${v}.a" || die
					liblist+="libx265_${v}.a;"
				done
				mycmakeargs+=(
					-DEXTRA_LIB="${liblist}"
					-DEXTRA_LINK_FLAGS=-L.
					-DLINKED_10BIT=$(usex 10bit)
					-DLINKED_12BIT=$(usex 12bit)
				)
				# we have to handle ppc here and not in multilib_src_configure
				# because we want those flags apply ONLY to "main" variant
				if [[ ${ABI} = ppc* ]] ; then
					myabicmakeargs+=(
						-DCPU_POWER8=$(usex power8 ON OFF)
						-DENABLE_ALTIVEC=$(usex cpu_flags_ppc_altivec ON OFF)
					)
				fi
			fi
			;;
		*)
			die "Unknown variant: ${MULTIBUILD_VARIANT}";;
	esac

	cmake_src_configure
	popd >/dev/null || die
}

multilib_src_configure() {
	local myabicmakeargs=(
		$(multilib_is_native_abi || echo "-DENABLE_CLI=OFF")
		-DENABLE_PIC=ON
		-DENABLE_LIBNUMA=$(usex numa ON OFF)
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)

	local supports_asm=yes

	if [[ ${ABI} = x86 ]] ; then
		if use asm ; then
			# Bug #528202
			ewarn "x86 asm is not PIC-safe, disabling it."
			supports_asm=no
		fi
	elif [[ ${ABI} = x32 ]] ; then
		if use asm ; then
			# bug #510890
			ewarn "x32 ABI doesn't support asm"
			supports_asm=no
		fi
	elif [[ ${ABI} = arm ]] ; then
		if use asm && use cpu_flags_arm_neon ; then
			supports_asm=yes
		elif use asm ; then
			ewarn "arm asm is not PIC-safe, disabling it."
			supports_asm=no
		fi
	elif [[ ${ABI} = ppc* ]] ; then
		if use asm ; then
			ewarn "ppc64 uses altivec instead of asm, disabling it."
			supports_asm=no
		fi
	fi

	if [[ "${supports_asm}" = yes ]] && use asm ; then
		myabicmakeargs+=( -DENABLE_ASSEMBLY=ON )

		if multilib_is_native_abi ; then
			myabicmakeargs+=( -DENABLE_TESTS=$(usex test ON OFF) )
		fi
	else
		myabicmakeargs+=( -DENABLE_ASSEMBLY=OFF )
	fi

	local MULTIBUILD_VARIANTS=( $(x265_get_variants) )
	multibuild_foreach_variant x265_variant_src_configure
}

multilib_src_compile() {
	local MULTIBUILD_VARIANTS=( $(x265_get_variants) )
	multibuild_foreach_variant cmake_src_compile
}

x265_variant_src_test() {
	if [[ -x "${BUILD_DIR}/test/TestBench" ]] ; then
		"${BUILD_DIR}/test/TestBench" || die
	else
		einfo "Unit tests check only assembly."
		einfo "You do not seem to have any for ABI=${ABI}, x265 variant=${MULTIBUILD_VARIANT}"
		einfo "Skipping tests."
	fi
}

multilib_src_test() {
	local MULTIBUILD_VARIANTS=( $(x265_get_variants) )
	multibuild_foreach_variant x265_variant_src_test
}

multilib_src_install() {
	# Install only "main" variant since the others are already linked into it.
	local MULTIBUILD_VARIANTS=( "main" )
	multibuild_foreach_variant cmake_src_install
}

multilib_src_install_all() {
	dodoc -r "${S}/../doc/"*

	# we don't install *.a files for all variants,
	# so just delete these files instead of pretending
	# real USE=static-libs support
	find "${ED}" -name "*.a" -delete || die
}
