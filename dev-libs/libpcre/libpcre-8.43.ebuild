# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib libtool flag-o-matic toolchain-funcs multilib-minimal preserve-libs usr-ldscript

DESCRIPTION="Perl-compatible regular expression library"
HOMEPAGE="http://www.pcre.org/"
MY_P="pcre-${PV/_rc/-RC}"
if [[ ${PV} != *_rc* ]] ; then
	# Only the final releases are available here.
	SRC_URI="mirror://sourceforge/pcre/${MY_P}.tar.bz2
		ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${MY_P}.tar.bz2"
else
	SRC_URI="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/Testing/${MY_P}.tar.bz2"
fi

LICENSE="BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv s390 ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="bzip2 +cxx +jit libedit pcre16 pcre32 +readline +recursion-limit static-libs unicode zlib"
REQUIRED_USE="readline? ( !libedit )
	libedit? ( !readline )"

RDEPEND="
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	libedit? ( dev-libs/libedit )
	readline? ( sys-libs/readline:0= )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pcre-config
)

PATCHES=(
	"${FILESDIR}"/${PN}-8.41-fix-stack-size-detection.patch
)

src_prepare() {
	default
	sed -i -e "s:-lpcre ::" libpcrecpp.pc.in || die
	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		--with-match-limit-recursion=$(usex recursion-limit 8192 MATCH_LIMIT)
		$(multilib_native_use_enable bzip2 pcregrep-libbz2)
		$(use_enable cxx cpp)
		$(use_enable jit)
		$(use_enable jit pcregrep-jit)
		$(use_enable pcre16)
		$(use_enable pcre32)
		$(multilib_native_use_enable libedit pcretest-libedit)
		$(multilib_native_use_enable readline pcretest-libreadline)
		$(use_enable static-libs static)
		$(use_enable unicode utf)
		$(use_enable unicode unicode-properties)
		$(multilib_native_use_enable zlib pcregrep-libz)
		--enable-pcre8
		--enable-shared
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake V=1 $(multilib_is_native_abi || echo "bin_PROGRAMS=")
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		$(multilib_is_native_abi || echo "bin_PROGRAMS= dist_html_DATA=") \
		install
	gen_usr_ldscript -a pcre
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die
}

pkg_preinst() {
	preserve_old_lib /$(get_libdir)/libpcre.so.0
}

pkg_postinst() {
	preserve_old_lib_notify /$(get_libdir)/libpcre.so.0
}
