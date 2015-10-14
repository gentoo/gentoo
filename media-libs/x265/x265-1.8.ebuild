# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib multilib flag-o-matic

if [[ ${PV} = 9999* ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/multicoreware/x265"
else
	SRC_URI="
		https://bitbucket.org/multicoreware/x265/downloads/${PN}_${PV}.tar.gz
		http://ftp.videolan.org/pub/videolan/x265/${PN}_${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Library for encoding video streams into the H.265/HEVC format"
HOMEPAGE="http://x265.org/"

LICENSE="GPL-2"
# subslot = libx265 soname
SLOT="0/68"
IUSE="+10bit test"

ASM_DEPEND=">=dev-lang/yasm-1.2.0"
RDEPEND=""
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
}

multilib_src_configure() {
	append-cflags -fPIC
	append-cxxflags -fPIC
	local mycmakeargs=(
		$(cmake-utils_use_enable test TESTS)
		$(multilib_is_native_abi || echo "-DENABLE_CLI=OFF")
		-DHIGH_BIT_DEPTH=$(usex 10bit "ON" "OFF")
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)

	if [[ ${ABI} = x86 ]] ; then
		use 10bit && ewarn "Disabling 10bit support on x86 as it does not build (or requires to disable assembly optimizations)"
		mycmakeargs+=( -DHIGH_BIT_DEPTH=OFF )
	elif [[ ${ABI} = x32 ]] ; then
		# bug #510890
		mycmakeargs+=( -DENABLE_ASSEMBLY=OFF )
	fi

	cmake-utils_src_configure
}

src_configure() {
	multilib_parallel_foreach_abi multilib_src_configure
}

multilib_src_test() {
	if has ${MULTILIB_ABI_FLAG} abi_x86_32 abi_x86_64 ; then
		cd "${BUILD_DIR}/test" || die
		for i in TestBench ; do
			./${i} || die
		done
	fi
}

src_test() {
	multilib_foreach_abi multilib_src_test
}

src_install() {
	cmake-multilib_src_install
	dodoc -r "${S}/../doc/"*
}
