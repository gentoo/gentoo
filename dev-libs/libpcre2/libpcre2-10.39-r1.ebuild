# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool multilib-minimal usr-ldscript

PATCH_SET="${PN}-10.36-patchset-01.tar.xz"

DESCRIPTION="Perl-compatible regular expression library"
HOMEPAGE="https://www.pcre.org/"
MY_P="pcre2-${PV/_rc/-RC}"
if [[ ${PV} != *_rc* ]] ; then
	# Only the final releases are available here.
	SRC_URI="mirror://sourceforge/pcre/${MY_P}.tar.bz2
		https://ftp.pcre.org/pub/pcre/${MY_P}.tar.bz2
		https://github.com/PhilipHazel/pcre2/releases/download/${MY_P}/${MY_P}.tar.bz2"
else
	SRC_URI="https://ftp.pcre.org/pub/pcre/Testing/${MY_P}.tar.bz2"
fi

if [[ -n "${PATCH_SET}" ]] ; then
	SRC_URI+=" https://dev.gentoo.org/~whissi/dist/${PN}/${PATCH_SET}
		https://dev.gentoo.org/~polynomial-c/dist/${PATCH_SET}"
fi

LICENSE="BSD"
SLOT="0/3" # libpcre2-posix.so version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 +jit libedit +pcre16 pcre32 +readline static-libs unicode zlib"
REQUIRED_USE="?? ( libedit readline )"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	bzip2? ( app-arch/bzip2 )
	libedit? ( dev-libs/libedit )
	readline? ( sys-libs/readline:0= )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pcre2-config
)

src_prepare() {
	if [[ -d "${WORKDIR}/patches" ]] ; then
		rm "${WORKDIR}"/patches/pcre2-10.36-001-issue2698.patch || die
		eapply "${WORKDIR}"/patches
	fi

	default

	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-pcre2-8
		--enable-shared
		$(multilib_native_use_enable bzip2 pcre2grep-libbz2)
		$(multilib_native_use_enable libedit pcre2test-libedit)
		$(multilib_native_use_enable readline pcre2test-libreadline)
		$(multilib_native_use_enable zlib pcre2grep-libz)
		$(use_enable jit)
		$(use_enable jit pcre2grep-jit)
		$(use_enable pcre16 pcre2-16)
		$(use_enable pcre32 pcre2-32)
		$(use_enable static-libs static)
		$(use_enable unicode)
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
	multilib_is_native_abi && gen_usr_ldscript -a pcre2-posix
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
}
