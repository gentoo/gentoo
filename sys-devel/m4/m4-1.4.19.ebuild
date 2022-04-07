# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/m4.asc
inherit verify-sig

DESCRIPTION="GNU macro processor"
HOMEPAGE="https://www.gnu.org/software/m4/m4.html"
if [[ ${PV} == *_beta* ]] ; then
	MY_P="${PN}-1.4.18d"
	SRC_URI="https://alpha.gnu.org/gnu/${PN}/${MY_P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://alpha.gnu.org/gnu/${PN}/${MY_P}.tar.xz.sig )"
	S="${WORKDIR}/${MY_P}"
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	SRC_URI+=" https://dev.gentoo.org/~floppym/dist/${P}-test-198-sysval-r1.patch.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="examples nls"

RDEPEND="
	virtual/libiconv
	nls? (
		sys-devel/gettext
		virtual/libintl
	)"
DEPEND="${RDEPEND}"
# Remember: cannot dep on autoconf since it needs us
BDEPEND="app-arch/xz-utils
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-m4 )"

PATCHES=(
	"${FILESDIR}"/ppc-musl.patch
	"${WORKDIR}"/${P}-test-198-sysval-r1.patch
)

src_unpack() {
	if use verify-sig ; then
		# Needed for downloaded patch (which is unsigned, which is fine)
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.sig}
	fi

	default
}

src_configure() {
	local -a myeconfargs=(
		--enable-changeword

		--with-packager="Gentoo Linux"
		--with-packager-version="${PVR}"
		--with-packager-bug-reports="https://bugs.gentoo.org/"

		$(usex nls '' '--disable-nls')

		# Disable automagic dependency over libsigsegv; see bug #278026
		ac_cv_libsigsegv=no
	)

	[[ ${USERLAND} != GNU ]] && myeconfargs+=( --program-prefix=g )

	econf "${myeconfargs[@]}"
}

src_test() {
	[[ -d /none ]] && die "m4 tests will fail with /none/" #244396
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
