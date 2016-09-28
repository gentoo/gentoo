# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs multilib-minimal

LIBVPX_TESTDATA_VER=1.6.0

DESCRIPTION="WebM VP8 and VP9 Codec SDK"
HOMEPAGE="http://www.webmproject.org"
SRC_URI="http://storage.googleapis.com/downloads.webmproject.org/releases/webm/${P}.tar.bz2
	test? ( mirror://gentoo/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.bz2 )"

LICENSE="BSD"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 doc cpu_flags_x86_mmx postproc cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 +highbitdepth static-libs svc test +threads"

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

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
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

	local myconf
	if multilib_is_native_abi; then
		myconf+=" $(use_enable doc install-docs) $(use_enable doc docs)"
	else
		# not needed for multilib and will be overwritten anyway.
		myconf+=" --disable-examples --disable-install-docs --disable-docs"
	fi

	# #498364: sse doesn't work without sse2 enabled,
	"${S}/configure" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--enable-pic \
		--enable-vp8 \
		--enable-vp9 \
		--enable-shared \
		--extra-cflags="${CFLAGS}" \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable cpu_flags_x86_avx2 avx2) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable postproc) \
		$(use cpu_flags_x86_sse2 && use_enable cpu_flags_x86_sse sse || echo --disable-sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse4_1) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable svc experimental) $(use_enable svc spatial-svc) \
		$(use_enable static-libs static) \
		$(use_enable test unit-tests) \
		$(use_enable threads multithread) \
		$(use_enable highbitdepth vp9-highbitdepth) \
		${myconf} \
		|| die
}

multilib_src_compile() {
	# build verbose by default and do not build examples that will not be installed
	emake verbose=yes GEN_EXAMPLES=
}

multilib_src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}:${LD_LIBRARY_PATH}" \
		emake verbose=yes GEN_EXAMPLES=  LIBVPX_TEST_DATA_PATH="${WORKDIR}/${PN}-testdata" test
}

multilib_src_install() {
	emake verbose=yes GEN_EXAMPLES= DESTDIR="${D}" install
	multilib_is_native_abi && use doc && dodoc -r docs/html
}
