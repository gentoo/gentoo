# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/grep.asc
inherit branding flag-o-matic verify-sig

DESCRIPTION="GNU regular expression matcher"
HOMEPAGE="https://www.gnu.org/software/grep/"

if [[ ${PV} == *_p* ]] ; then
	# Subscribe to the 'platform-testers' ML to find these.
	# Useful to test on our especially more niche arches and report issues upstream.
	MY_COMMIT="69-a4628"
	MY_P=${PN}-$(ver_cut 1-2).${MY_COMMIT}
	SRC_URI="https://meyering.net/${PN}/${MY_P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://meyering.net/${PN}/${MY_P}.tar.xz.sig )"
	S="${WORKDIR}"/${MY_P}
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+egrep-fgrep nls pcre static test-full"

# We lack dev-libs/libsigsegv[static-libs] for now
REQUIRED_USE="static? ( !sparc )"

LIB_DEPEND="
	pcre? ( >=dev-libs/libpcre2-10.42-r1[static-libs(+)] )
	sparc? ( dev-libs/libsigsegv )
"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	nls? ( virtual/libintl )
	virtual/libiconv
"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-grep )
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

QA_CONFIG_IMPL_DECL_SKIP=(
	# Either gnulib FPs or fixed in newer autoconf, not worth autoreconf here for now?
	MIN
	alignof
	static_assert
)

PATCHES=(
	"${FILESDIR}"/${P}-write-error-test.patch
)

src_prepare() {
	default

	# bug #523898
	sed -i \
		-e "s:@SHELL@:${EPREFIX}/bin/sh:g" \
		-e "s:@grep@:${EPREFIX}/bin/grep:" \
		src/egrep.sh || die

	# Drop when grep-3.11-100k-files-dir.patch is gone
	#touch aclocal.m4 config.hin configure {,doc/,gnulib-tests/,lib/,src/,tests/}Makefile.in || die
}

src_configure() {
	use static && append-ldflags -static

	export RUN_{VERY_,}EXPENSIVE_TESTS=$(usex test-full yes no)

	# We used to turn this off unconditionally (bug #673524) but we now
	# allow it for cases where libsigsegv is better for userspace handling
	# of stack overflows.
	# In particular, it's necessary for sparc: bug #768135
	export ac_cv_libsigsegv=$(usex sparc)

	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		$(use_enable nls)
		$(use_enable pcre perl-regexp)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use egrep-fgrep ; then
		# Delete the upstream wrapper variants which warn on egrep+fgrep use
		rm "${ED}"/bin/{egrep,fgrep} || die

		into /
		# Install egrep, fgrep which don't warn.
		#
		# We do this by default to avoid breakage in old scripts
		# and such which don't expect unexpected output on stderr,
		# we've had examples of builds failing because foo-config
		# starts returning a warning.
		#
		# https://lists.gnu.org/archive/html/bug-grep/2022-10/msg00000.html
		newbin - egrep <<-EOF
		#!/usr/bin/env sh
		exec "${EPREFIX}/bin/grep" -E "\$@"
		EOF

		newbin - fgrep <<-EOF
		#!/usr/bin/env sh
		exec "${EPREFIX}/bin/grep" -F "\$@"
		EOF
	fi
}
