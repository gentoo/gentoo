# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic libtool ltprune multilib-minimal toolchain-funcs

DESCRIPTION="Perl-compatible regular expression library"
HOMEPAGE="http://www.pcre.org/"
MY_P="pcre2-${PV/_rc/-RC}"
if [[ ${PV} != *_rc* ]] ; then
	# Only the final releases are available here.
	SRC_URI="mirror://sourceforge/pcre/${MY_P}.tar.bz2
		ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${MY_P}.tar.bz2"
else
	SRC_URI="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/Testing/${MY_P}.tar.bz2"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 +jit libedit pcre16 pcre32 +readline +recursion-limit static-libs unicode zlib"
REQUIRED_USE="?? ( libedit readline )"

RDEPEND="bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	libedit? ( dev-libs/libedit )
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	userland_GNU? ( >=sys-apps/findutils-4.4.0 )"

S="${WORKDIR}/${MY_P}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pcre2-config
)

src_prepare() {
	default

	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-pcre2-8
		--enable-shared
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
		--with-match-limit-depth=$(usex recursion-limit 8192 MATCH_LIMIT)
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
	prune_libtool_files
}
