# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Similar to dd but can copy from source with errors"
HOMEPAGE="http://www.garloff.de/kurt/linux/ddrescue/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.code.sf.net/p/ddrescue/code"
	EGIT_BRANCH=DD_RESCUE_1_99_BRANCH
	inherit git-r3
else
	SRC_URI="http://www.garloff.de/kurt/linux/ddrescue/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="cpu_flags_x86_avx2 lzo lzma cpu_flags_x86_sse4_2 static test xattr"
RESTRICT="!test? ( test )"

RDEPEND="
	lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/attr )
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		lzo? (
			app-arch/lzop
		)
	)
"

src_prepare() {
	default

	if ! use cpu_flags_x86_sse4_2; then
		sed -i \
			-e 's:^CC_FLAGS_CHECK(-msse4.2,SSE42):#&:' \
			configure.ac || die
	fi

	if ! use cpu_flags_x86_avx2; then
		sed -i \
			-e 's:^CC_FLAGS_CHECK(-mavx2,AVX2):#&:' \
			configure.ac || die
	fi

	eautoreconf

	sed -i \
		-e 's:\(-ldl\):$(LDFLAGS) \1:' \
		-e 's:\(-shared\):$(CFLAGS) $(LDFLAGS) \1:' \
		Makefile || die
}

src_configure() {
	use static && append-ldflags -static

	# OpenSSL is only used by a random helper tool we don't install.
	export ac_cv_header_attr_xattr_h=$(usex xattr)
	export ac_cv_header_openssl_evp_h=no
	export ac_cv_lib_crypto_EVP_aes_192_ctr=no
	export ac_cv_lib_lzo2_lzo1x_1_compress=$(usex lzo)
	export ac_cv_header_lzo_lzo1x_h=$(usex lzo)
	export ac_cv_header_lzma_h=$(usex lzma)
	export ac_cv_lib_lzma_lzma_easy_encoder=$(usex lzma)
	econf
}

_emake() {
	local arch
	case ${ARCH} in
		x86)   arch=i386;;
		amd64) arch=x86_64;;
		arm)   arch=arm;;
		arm64) arch=aarch64;;
	esac

	local os=$(usex kernel_linux Linux IDK)

	# HAVE_LZO is special as it's checked for emptiness in test_crypt.sh.
	# We could try make RDRND and friends controlled via USE but it's too brittle,
	# see bug #947105.
	emake \
		MACH="${arch}" \
		OS="${os}" \
		HAVE_SSE42=$(usex cpu_flags_x86_sse4_2 1 0) \
		HAVE_AVX2=$(usex cpu_flags_x86_avx2 1 0) \
		HAVE_LZMA=$(usex lzma 1 0) \
		HAVE_LZO=$(usev lzo 1) \
		HAVE_OPENSSL=0 \
		RPM_OPT_FLAGS="${CFLAGS} ${CPPFLAGS}" \
		CFLAGS_OPT='$(CFLAGS)' \
		LDFLAGS="${LDFLAGS} -Wl,-rpath,${EPREFIX}/usr/$(get_libdir)/${PN}" \
		CC="$(tc-getCC)" \
		"$@"
}

src_compile() {
	_emake
}

src_test() {
	if ! use lzo ; then
		sed -i \
			-e '/^LZOP=/s:LZOP=.*:LZOP=:' \
			-e '/^LZOP=/a exit 0' \
			test_lzo.sh || die
	fi

	_emake check
}

src_install() {
	# easier to install by hand than trying to make sense of the Makefile.
	dobin dd_rescue
	dodir /usr/$(get_libdir)/${PN}
	cp -pPR libddr_*.so "${ED}"/usr/$(get_libdir)/${PN}/ || die
	dodoc README.dd_rescue
	doman dd_rescue.1
	use lzo && doman ddr_lzo.1
}
