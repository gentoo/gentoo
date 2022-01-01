# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit toolchain-funcs multilib-minimal

# To create a new testdata tarball:
# 1. Unpack source tarball or checkout git tag
# 2. mkdir libvpx-testdata
# 3. export LIBVPX_TEST_DATA_PATH=libvpx-testdata
# 4. configure --enable-unit-tests --enable-vp9-highbitdepth
# 5. make testdata
# 6. tar -caf libvpx-testdata-${MY_PV}.tar.xz libvpx-testdata

LIBVPX_TESTDATA_VER=1.9.0

DESCRIPTION="WebM VP8 and VP9 Codec SDK"
HOMEPAGE="https://www.webmproject.org"
SRC_URI="https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://dev.gentoo.org/~whissi/dist/libvpx/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.xz )"

LICENSE="BSD"
SLOT="0/6"
KEYWORDS="amd64 arm arm64 ~ia64 ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc +highbitdepth postproc static-libs svc test +threads"

REQUIRED_USE="test? ( threads )"

# Disable test phase when USE="-test"
RESTRICT="!test? ( test )"

BDEPEND="abi_x86_32? ( dev-lang/yasm )
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
	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/ #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn
	addpredict /session_mm_cli0.sem #nowarn
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
		$(use_enable postproc)
		$(use_enable svc experimental)
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

	# powerpc toolchain is not recognized anymore, #694368
	[[ ${CHOST} == powerpc-* ]] && myconfargs+=( --force-target=generic-gnu )

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

	echo "${S}"/configure "${myconfargs[@]}" >&2
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
