# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs multilib-minimal

# To create a new testdata tarball:
# 1. Unpack source tarbll or checkout git tag
# 2. export LIBVPX_TEST_DATA_PATH=libvpx-testdata
# 3. configure --enable-unit-tests --enable-vp9-highbitdepth
# 4. make testdata
# 5. tar -cjf libvpx-testdata-${MY_PV}.tar.bz2 libvpx-testdata

LIBVPX_TESTDATA_VER=1.7.0

DESCRIPTION="WebM VP8 and VP9 Codec SDK"
HOMEPAGE="http://www.webmproject.org"
SRC_URI="https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( mirror://gentoo/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.xz )"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 doc cpu_flags_x86_mmx postproc cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 +highbitdepth static-libs svc test +threads"

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
	test? ( threads )
"

# Disable test phase when USE="-test"
RESTRICT="!test? ( test )"

RDEPEND="abi_x86_32? ( !app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

PATCHES=(
	"${FILESDIR}/libvpx-1.3.0-sparc-configure.patch" # 501010
)

src_configure() {
	# https://bugs.gentoo.org/show_bug.cgi?id=384585
	# https://bugs.gentoo.org/show_bug.cgi?id=465988
	# copied from php-pear-r1.eclass
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/
	addpredict /var/lib/net-snmp/mib_indexes
	addpredict /session_mm_cli0.sem
	multilib-minimal_src_configure
}

multilib_src_configure() {
	unset CODECS #357487

	# #498364: sse doesn't work without sse2 enabled,
	local myconfargs=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-pic
		--enable-vp8
		--enable-vp9
		--enable-shared
		--extra-cflags="${CFLAGS}"
		$(use_enable cpu_flags_x86_avx avx)
		$(use_enable cpu_flags_x86_avx2 avx2)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable postproc)
		$(use cpu_flags_x86_sse2 && use_enable cpu_flags_x86_sse sse || echo --disable-sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_sse3 sse3)
		$(use_enable cpu_flags_x86_sse4_1 sse4_1)
		$(use_enable cpu_flags_x86_ssse3 ssse3)
		$(use_enable svc experimental) $(use_enable svc spatial-svc)
		$(use_enable static-libs static)
		$(use_enable test unit-tests)
		$(use_enable threads multithread)
		$(use_enable highbitdepth vp9-highbitdepth)
	)

	# let the build system decide which AS to use (it honours $AS but
	# then feeds it with yasm flags without checking...) #345161
	tc-export AS
	case "${CHOST}" in
		i?86*) export AS=yasm;;
		x86_64*) export AS=yasm;;
	esac

	# Build with correct toolchain.
	tc-export CC CXX AR NM
	# Link with gcc by default, the build system should override this if needed.
	export LD="${CC}"

	if multilib_is_native_abi; then
		myconfargs+=( $(use_enable doc install-docs) $(use_enable doc docs) )
	else
		# not needed for multilib and will be overwritten anyway.
		myconfargs+=( --disable-examples --disable-install-docs --disable-docs )
	fi

	"${S}"/configure "${myconfargs[@]}"
}

multilib_src_compile() {
	# build verbose by default and do not build examples that will not be installed
	emake verbose=yes GEN_EXAMPLES=
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
