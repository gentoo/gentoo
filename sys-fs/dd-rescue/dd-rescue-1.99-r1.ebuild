# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs flag-o-matic multilib autotools

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

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

src_prepare() {
	epatch "${FILESDIR}/${MY_PN}-1.99-test_fix.patch"
	epatch "${FILESDIR}/${MY_PN}-1.99-musl.patch"

	sed -i \
		-e 's:-ldl:$(LDFLAGS) -ldl:' \
		-e 's:-shared:$(CFLAGS) $(LDFLAGS) -shared:' \
		Makefile
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	# OpenSSL is only used by a random helper tool we don't install.
	ac_cv_header_attr_xattr_h=$(usex xattr) \
	ac_cv_header_openssl_evp_h=no \
	ac_cv_lib_lzo2_lzo1x_1_compress=$(usex lzo) \
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
