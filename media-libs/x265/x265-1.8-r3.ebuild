# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib-minimal multilib multibuild flag-o-matic

if [[ ${PV} = 9999* ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/multicoreware/x265"
else
	SRC_URI="
		https://bitbucket.org/multicoreware/x265/downloads/${PN}_${PV}.tar.gz
		http://ftp.videolan.org/pub/videolan/x265/${PN}_${PV}.tar.gz"
	KEYWORDS="amd64 ~arm hppa ~ppc ppc64 x86"
fi

DESCRIPTION="Library for encoding video streams into the H.265/HEVC format"
HOMEPAGE="http://x265.org/"

LICENSE="GPL-2"
# subslot = libx265 soname
SLOT="0/68"
IUSE="+10bit 12bit numa pic test"

ASM_DEPEND=">=dev-lang/yasm-1.2.0"
RDEPEND="numa? ( >=sys-process/numactl-2.0.10-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	abi_x86_32? ( ${ASM_DEPEND} )
	abi_x86_64? ( ${ASM_DEPEND} )"

src_unpack() {
	if [[ ${PV} = 9999* ]]; then
		mercurial_src_unpack
		# Can't set it at global scope due to mercurial.eclass limitations...
		export S=${WORKDIR}/${P}/source
	else
		unpack ${A}
		export S="$(echo "${WORKDIR}/${PN}_"*"/source")"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-build-Disable-march-selection-from-CMakeLists.txt.patch"	# bug #510890
	epatch "${FILESDIR}/1.8-extralibs_order.patch"
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
	local variants=""
	use 12bit && variants+="main12 "
	use 10bit && variants+="main10 "
	variants+="main"
	echo "${variants}"
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
			if [[ ${ABI} = x86 ]] ; then
				mycmakeargs+=( -DENABLE_ASSEMBLY=OFF )
			fi
			;;
		"main10")
			mycmakeargs+=(
				-DHIGH_BIT_DEPTH=ON
				-DEXPORT_C_API=OFF
				-DENABLE_SHARED=OFF
				-DENABLE_CLI=OFF
			)
			if [[ ${ABI} = x86 ]] ; then
				mycmakeargs+=( -DENABLE_ASSEMBLY=OFF )
			fi
			;;
		"main")
			if (( "${#MULTIBUILD_VARIANTS[@]}" > 1 )) ; then
				local myvariants=( "${MULTIBUILD_VARIANTS[@]}" )
				unset myvariants[${#MULTIBUILD_VARIANTS[@]}-1]
				local liblist=""
				for v in "${myvariants[@]}" ; do
					ln -s "${BUILD_DIR%-*}-${v}/libx265.a" "libx265_${v}.a" ||	die
					liblist+="libx265_${v}.a;"
				done
				mycmakeargs+=(
					-DEXTRA_LIB="${liblist}"
					-DEXTRA_LINK_FLAGS=-L.
					-DLINKED_10BIT=$(usex 10bit)
					-DLINKED_12BIT=$(usex 12bit)
				)
			fi
			;;
		*)
			die "Unknown variant: ${MULTIBUILD_VARIANT}";;
	esac
	cmake-utils_src_configure
	popd >/dev/null || die
}

multilib_src_configure() {
	append-cflags -fPIC
	append-cxxflags -fPIC
	local myabicmakeargs=(
		$(cmake-utils_use_enable test TESTS)
		$(multilib_is_native_abi || echo "-DENABLE_CLI=OFF")
		-DCMAKE_DISABLE_FIND_PACKAGE_Numa=$(usex numa OFF ON)
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)

	if [[ ${ABI} = x86 ]] ; then
		# Bug #528202
		if use pic ; then
			ewarn "PIC has been requested but x86 asm is not PIC-safe, disabling it."
			myabicmakeargs+=( -DENABLE_ASSEMBLY=OFF )
		fi
	elif [[ ${ABI} = x32 ]] ; then
		# bug #510890
		myabicmakeargs+=( -DENABLE_ASSEMBLY=OFF )
	fi

	local MULTIBUILD_VARIANTS=( $(x265_get_variants) )
	multibuild_foreach_variant x265_variant_src_configure
}

multilib_src_compile() {
	local MULTIBUILD_VARIANTS=( $(x265_get_variants) )
	multibuild_foreach_variant cmake-utils_src_compile
}

x265_variant_src_test() {
	if [ -x "${BUILD_DIR}/test/TestBench" ] ; then
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
	multibuild_foreach_variant cmake-utils_src_install
}

multilib_src_install_all() {
	dodoc -r "${S}/../doc/"*
}
