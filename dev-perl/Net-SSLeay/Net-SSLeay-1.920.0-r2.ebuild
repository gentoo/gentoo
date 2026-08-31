# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHRISN
DIST_VERSION=1.92
DIST_EXAMPLES=("examples/*")
inherit perl-module toolchain-funcs

DESCRIPTION="Perl extension for using OpenSSL"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal examples"

RDEPEND="
	dev-libs/openssl:=
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	virtual/pkgconfig
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	test? (
		!minimal? (
			dev-perl/Test-Exception
			dev-perl/Test-Warn
			dev-perl/Test-NoWarnings
		)
		virtual/perl-Test-Simple
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.88-fix-network-tests.patch"
	"${FILESDIR}/${PN}-1.92-libressl.patch" #903001
	"${FILESDIR}/${PN}-1.92-use-openssl-version-string.patch"
)

PERL_RM_FILES=(
	# Hateful author tests
	't/local/01_pod.t'
	't/local/02_pod_coverage.t'
	't/local/kwalitee.t'
)

src_configure() {
	if use test && has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		export NETWORK_TESTS=yes
	else
		use test && einfo "Network tests will be skipped without DIST_TEST_OVERRIDE=~network"
		export NETWORK_TESTS=no
	fi
	export LIBDIR=$(get_libdir)
	export OPENSSL_PREFIX="${ESYSROOT}/usr"
	# Don't fix what isn't broken, let the build script figure the version out themselves
	# if they can do it. Cross compiling is one of the cases where they can't.
	tc-is-cross-compiler && export OPENSSL_VERSION_STRING="$("$(tc-getPKG_CONFIG)" --version opensll)"
	local myconf=(
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
	)
	if tc-is-cross-compiler; then
		# Let's have some fun trying to find perl's installation folder.
		local perl_dir perl_ver
		perl_ver="$(find "${ESYSROOT}/usr/bin" -name 'perl[0-9.]*')" # We may get something like /path/perl5.36.1
		perl_ver="${perl_ver##*/perl}"
		perl_ver="${perl_ver%.*}" # Remove the last digit
		perl_dir="${EPREFIX}/usr/${LIBDIR}/perl5/vendor_perl/${perl_ver}"
		[[ ! -d ${perl_dir} ]] && die "Could not find Perl's installation directory for '${ESYSROOT}'"

		perl_dir="${perl_dir}/$(cut -f1,3 -d- --output-delimiter=- <<<"${CHOST}")"
		myconf+=( INSTALLVENDORARCH="${perl_dir}" VENDORARCHEXP="${perl_dir}")
	fi
	perl-module_src_configure

	# The + is important, there are 2 lines that would match *
	sed -Ei "s,^LD_RUN_PATH\\s+=.*$,LD_RUN_PATH = ${EPREFIX}/usr/${LIBDIR}," Makefile \
		|| die "Could not remove LD_RUN_PATH reference"
}

src_compile() {
	mymake=(
		OPTIMIZE="${CFLAGS}"
		OPENSSL_PREFIX="${ESYSROOT}"/usr
	)
	perl-module_src_compile
}
