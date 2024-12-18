# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic multilib-minimal multibuild

DESCRIPTION="Library for encoding video streams into the H.265/HEVC format"
HOMEPAGE="https://www.x265.org/ https://bitbucket.org/multicoreware/x265_git/"

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/multicoreware/x265_git/"
	MY_P="${PN}-${PV}"
else
	SRC_URI="https://bitbucket.org/multicoreware/x265_git/downloads/${PN}_${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="amd64 arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv x86"
	MY_P="${PN}_${PV}"
fi

S="${WORKDIR}/${MY_P}/source"
unset MY_P

LICENSE="GPL-2"
# subslot = libx265 soname
SLOT="0/209"
IUSE="+10bit +12bit cpu_flags_ppc_vsx2 numa test"
RESTRICT="!test? ( test )"

RDEPEND="numa? ( >=sys-process/numactl-2.0.10-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
ASM_DEPEND=">=dev-lang/nasm-2.13"
BDEPEND="
	abi_x86_32? ( ${ASM_DEPEND} )
	abi_x86_64? ( ${ASM_DEPEND} )"

PATCHES=(
	"${FILESDIR}/${PN}-9999-arm.patch"
	"${FILESDIR}/neon.patch"
	"${FILESDIR}/tests.patch"
	"${FILESDIR}/test-ns.patch"
	"${FILESDIR}/${PN}-3.5-r5-cpp-std.patch"
	"${FILESDIR}/${PN}-3.5-r5-gcc15.patch"
	"${FILESDIR}/${PN}-3.6-test-ns_2.patch"
	"${FILESDIR}/${PN}-3.6-cmake-cleanup.patch"
	"${FILESDIR}/${PN}-3.6-code-cleanup.patch"
)

pkg_setup() {
	variants=(
		$(usev 12bit "main12")
		$(usev 10bit "main10")
	)
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
# allow disabling it

x265_variant_src_configure() {
	einfo "Configuring variant: ${MULTIBUILD_VARIANT} for ABI: ${ABI}"

	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DHIGH_BIT_DEPTH=ON
		-DEXPORT_C_API=OFF
		-DENABLE_SHARED=OFF
		-DENABLE_CLI=OFF
	)

	case "${MULTIBUILD_VARIANT}" in
		"main12")
			mycmakeargs+=(
				-DMAIN12=ON
			)
			;;
		"main10")
			mycmakeargs+=(
				-DENABLE_HDR10_PLUS=ON
			)
			;;
		*)
			die "Unknown variant: ${MULTIBUILD_VARIANT}";;
	esac
	cmake_src_configure
}

multilib_src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/875854
	# https://bitbucket.org/multicoreware/x265_git/issues/937/build-fails-with-lto
	filter-lto

	local mycmakeargs=(
		-DENABLE_PIC=ON
		-DENABLE_LIBNUMA="$(usex numa)"
		-DENABLE_SVT_HEVC="no" # missing
		-DENABLE_VTUNE="no" # missing
		-DGIT_ARCHETYPE=1 #814116
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)
	if ! multilib_is_native_abi; then
		mycmakeargs+=(
			-DENABLE_CLI="no"
		)
	fi

	# Unfortunately, the asm for x86/x32/arm isn't PIC-safe.
	# x86 # Bug #528202, bug #913412
	# x32 # bug #510890
	if [[ ${ABI} = x86 ]] || [[ ${ABI} = x32 ]] || [[ ${ABI} = arm ]] ; then
		mycmakeargs+=(
			-DENABLE_ASSEMBLY=OFF
			# ENABLE_TESTS requires ENABLE_ASSEMBLY=ON to be visible
			# source/CMakeLists.txt:858
			# -DENABLE_TESTS="no" #728748
		)
	else
		mycmakeargs+=(
			-DENABLE_TESTS="$(usex test)"
		)
	fi

	if [[ ${ABI} = ppc* ]] ; then
		# upstream uses mix of altivec + power8 vectors
		# it's impossible to enable altivec without CPU_POWER8
		# and it does not work on ppc32
		# so we toggle both variables together
		mycmakeargs+=(
			-DCPU_POWER8="$(usex cpu_flags_ppc_vsx2)"
			-DENABLE_ALTIVEC="$(usex cpu_flags_ppc_vsx2)"
		)
	fi

	local MULTIBUILD_VARIANTS=( "${variants[@]}" )
	if [[ "${#MULTIBUILD_VARIANTS[@]}" -gt 1 ]] ; then
		multibuild_foreach_variant x265_variant_src_configure

		local liblist="" v=
		for v in "${MULTIBUILD_VARIANTS[@]}" ; do
			ln -s "${BUILD_DIR}-${v}/libx265.a" "${BUILD_DIR}/libx265_${v}.a" || die
			liblist+="libx265_${v}.a;"
		done

		mycmakeargs+=(
			-DEXTRA_LIB="${liblist}"
			-DEXTRA_LINK_FLAGS="-L${BUILD_DIR}"
			-DLINKED_10BIT"=$(usex 10bit)"
			-DLINKED_12BIT="$(usex 12bit)"
		)
	fi

	cmake_src_configure
}

multilib_src_compile() {
	local MULTIBUILD_VARIANTS=( "${variants[@]}" )
	if [[ "${#MULTIBUILD_VARIANTS[@]}" -gt 1 ]] ; then
		multibuild_foreach_variant cmake_src_compile
	fi
	cmake_src_compile
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
	local MULTIBUILD_VARIANTS=( "${variants[@]}" )
	if [[ "${#MULTIBUILD_VARIANTS[@]}" -gt 1 ]] ; then
		multibuild_foreach_variant x265_variant_src_test
	fi
	x265_variant_src_test
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	dodoc -r "${S}/../doc/"*

	# we don't install *.a files for all variants,
	# so just delete these files instead of pretending
	# real USE=static-libs support
	find "${ED}" -name "*.a" -delete || die
}
