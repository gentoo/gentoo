# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs multilib-minimal

# To create a new testdata tarball:
# 1. Unpack source tarball or checkout git tag
# 2. mkdir libvpx-testdata
# 3. export LIBVPX_TEST_DATA_PATH=libvpx-testdata
# 4. ./configure --enable-unit-tests --enable-vp9-highbitdepth
# 5. make testdata
# 6. tar -caf libvpx-testdata-${MY_PV}.tar.xz libvpx-testdata

LIBVPX_TESTDATA_VER=1.13.1

DESCRIPTION="WebM VP8 and VP9 Codec SDK"
HOMEPAGE="https://www.webmproject.org"
SRC_URI="
	https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.xz )
"

LICENSE="BSD"
SLOT="0/8"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_ppc_vsx3 doc +highbitdepth postproc static-libs test +threads"
REQUIRED_USE="test? ( threads )"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-lang/perl
	abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

PATCHES=(
	# bug #501010
	"${FILESDIR}/${PN}-1.3.0-sparc-configure.patch"
)

src_configure() {
	# bug #384585, bug #465988
	# copied from php-pear-r1.eclass
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/
	addpredict /var/lib/net-snmp/mib_indexes
	addpredict /session_mm_cli0.sem
	multilib-minimal_src_configure
}

multilib_src_configure() {
	# bug #357487
	unset CODECS
	# bug #905986
	unset DIST_DIR

	# bug #498364: sse doesn't work without sse2 enabled,
	local myconfargs=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-pic
		--enable-vp8
		--enable-vp9
		--enable-shared
		--disable-optimizations
		$(use_enable postproc)
		$(use_enable static-libs static)
		$(use_enable test unit-tests)
		$(use_enable threads multithread)
		$(use_enable highbitdepth vp9-highbitdepth)
	)

	# let the build system decide which AS to use (it honours $AS but
	# then feeds it with yasm flags without checking...), bug #345161
	tc-export AS
	case "${CHOST}" in
		i?86*) export AS=yasm;;
		x86_64*) export AS=yasm;;
	esac

	# libvpx is fragile: both for tests at runtime.
	# We force using the generic target unless we know things work to
	# avoid runtime breakage on exotic arches.
	if [[ ${ABI} == amd64 ]] ; then
		myconfargs+=( --force-target=x86_64-linux-gcc )
	elif [[ ${ABI} == x86 ]] ; then
		myconfargs+=( --force-target=x86-linux-gcc )
	elif [[ ${ABI} == arm64 ]] ; then
		myconfargs+=( --force-target=arm64-linux-gcc )
	elif [[ ${ABI} == arm ]] && [[ ${CHOST} == *armv7* ]] ; then
		myconfargs+=( --force-target=armv7-linux-gcc )
	elif [[ ${ABI} == ppc64 ]] && [[ $(tc-endian) != big ]] && use cpu_flags_ppc_vsx3; then
		# only enable this target for at least power9 CPU running little-endian
		myconfargs+=( --force-target=ppc64le-linux-gcc )
	else
		myconfargs+=( --force-target=generic-gnu )
	fi

	# powerpc toolchain is not recognized anymore, bug #694368
	#[[ ${CHOST} == powerpc-* ]] && myconfargs+=( --force-target=generic-gnu )

	# Build with correct toolchain.
	tc-export CC CXX AR NM
	# Link with gcc by default, the build system should override this if needed.
	export LD="${CC}"

	if multilib_is_native_abi; then
		myconfargs+=( $(use_enable doc install-docs) $(use_enable doc docs) )
	else
		# Not needed for multilib and will be overwritten anyway.
		myconfargs+=( --disable-examples --disable-install-docs --disable-docs )
	fi

	edo "${S}"/configure "${myconfargs[@]}"
}

multilib_src_compile() {
	# Build verbose by default and do not build examples that will not be installed
	# Disable stripping of debug info, bug #752057
	# (only works as long as upstream does not use non-gnu strip)
	emake verbose=yes GEN_EXAMPLES= HAVE_GNU_STRIP=no
}

multilib_src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}"
	local -x LIBVPX_TEST_DATA_PATH="${WORKDIR}/${PN}-testdata"
	emake verbose=yes GEN_EXAMPLES= test
}

multilib_src_install() {
	emake verbose=yes GEN_EXAMPLES= DESTDIR="${D}" install

	multilib_is_native_abi && use doc && dodoc -r docs/html
}
