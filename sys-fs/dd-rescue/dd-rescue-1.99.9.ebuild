# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib toolchain-funcs

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Similar to dd but can copy from source with errors"
HOMEPAGE="http://www.garloff.de/kurt/linux/ddrescue/"
SRC_URI="http://www.garloff.de/kurt/linux/ddrescue/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cpu_flags_x86_avx2 lzo cpu_flags_x86_sse4_2 static xattr"

RDEPEND="lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.99.9-musl-r2.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:-ldl:$(LDFLAGS) -ldl:' \
		-e 's:-shared:$(CFLAGS) $(LDFLAGS) -shared:' \
		Makefile || die

	if ! use cpu_flags_x86_sse4_2; then
		sed -i \
			-e 's:^CC_FLAGS_CHECK(-msse4.2,SSE42):#&:' \
			configure.in || die
	fi

	if ! use cpu_flags_x86_avx2; then
		sed -i \
			-e 's:^CC_FLAGS_CHECK(-mavx2,AVX2):#&:' \
			configure.in || die
	fi

	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	# OpenSSL is only used by a random helper tool we don't install.
	ac_cv_header_attr_xattr_h=$(usex xattr) \
	ac_cv_header_openssl_evp_h=no \
	ac_cv_lib_crypto_EVP_aes_192_ctr=no \
	ac_cv_lib_lzo2_lzo1x_1_compress=$(usex lzo) \
	ac_cv_header_lzo_lzo1x_h=$(usex lzo) \
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

	# The Makefile is a mess.  Override a few vars rather than patch it.
	emake \
		MACH="${arch}" \
		OS="${os}" \
		HAVE_SSE42=$(usex cpu_flags_x86_sse4_2 1 0) \
		HAVE_AVX2=$(usex cpu_flags_x86_avx2 1 0) \
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
	append-cflags -fcommon # bug 707796
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
