# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/m4.asc
inherit branding flag-o-matic verify-sig

DESCRIPTION="GNU macro processor"
HOMEPAGE="https://www.gnu.org/software/m4/m4.html"
if [[ ${PV} == *_p* ]] ; then
	# Note: could put this in devspace, but if it's gone, we don't want
	# it in tree anyway. It's just for testing.
	MY_SNAPSHOT="$(ver_cut 1-3).65-bdd9"
	SRC_URI="
		https://alpha.gnu.org/gnu/${PN}/${PN}-${MY_SNAPSHOT}.tar.xz
		https://people.redhat.com/eblake/${PN}/${PN}-${MY_SNAPSHOT}.tar.xz
		verify-sig? (
			https://alpha.gnu.org/gnu/${PN}/${PN}-${MY_SNAPSHOT}.tar.xz.sig
			https://people.redhat.com/eblake/${PN}/${PN}-${MY_SNAPSHOT}.tar.xz.sig
		)
	"
	S="${WORKDIR}"/${PN}-${MY_SNAPSHOT}
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="examples nls"

RDEPEND="
	virtual/libiconv
	nls? (
		sys-devel/gettext
		virtual/libintl
	)
"
DEPEND="${RDEPEND}"
# Remember: cannot dep on autoconf since it needs us
BDEPEND="
	app-arch/xz-utils
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-m4 )
"

src_prepare() {
	default

	# touch generated files after patching m4, to avoid activating maintainer
	# mode
	# remove when loong-fix-build.patch is no longer necessary
	#touch ./aclocal.m4 ./lib/config.hin ./configure ./doc/stamp-vti || die
	#find . -name Makefile.in -exec touch {} + || die
}

src_configure() {
	# see https://bugs.gentoo.org/955947
	append-flags -Wno-error=format-security

	local -a myeconfargs=(
		--enable-changeword
		$(usex nls '' '--disable-nls')

		# Disable automagic dependency over libsigsegv; see bug #278026
		ac_cv_libsigsegv=no
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	[[ -d /none ]] && die "m4 tests will fail with /none/" # bug #244396
	emake check
}

src_install() {
	default

	# autoconf-2.60 for instance, first checks gm4, then m4.  If we don't have
	# gm4, it might find gm4 from outside the prefix on for instance Darwin
	use prefix && dosym m4 /usr/bin/gm4

	if use examples ; then
		dodoc -r examples
		rm -f "${ED}"/usr/share/doc/${PF}/examples/Makefile*
	fi
}
