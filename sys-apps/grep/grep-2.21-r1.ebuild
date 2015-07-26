# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/grep/grep-2.21-r1.ebuild,v 1.11 2015/07/21 15:58:19 vapier Exp $

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="GNU regular expression matcher"
HOMEPAGE="http://www.gnu.org/software/grep/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
	mirror://gentoo/${P}.tar.xz
	http://dev.gentoo.org/~polynomial-c/${P}-heap_buffer_overrun.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls pcre static"

LIB_DEPEND="pcre? ( >=dev-libs/libpcre-7.8-r1[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	nls? ( virtual/libintl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	static? ( ${LIB_DEPEND} )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	# Disable gnulib build test that has no impact on the source.
	# Re-enable w/next version bump (and gnulib is updated). #554728
	[[ ${PV} != "2.21" ]] && die "re-enable test #554728"
	echo 'exit 0' > gnulib-tests/test-update-copyright.sh || die

	sed -i \
		-e "s:@SHELL@:${EPREFIX}/bin/sh:g" \
		src/egrep.sh || die #523898

	epatch "${DISTDIR}/${P}-heap_buffer_overrun.patch"
}

src_configure() {
	use static && append-ldflags -static
	# Always use pkg-config to get lib info for pcre.
	export ac_cv_search_pcre_compile=$(
		usex pcre "$($(tc-getPKG_CONFIG) --libs $(usex static --static '') libpcre)" ''
	)
	econf \
		--bindir="${EPREFIX}"/bin \
		$(use_enable nls) \
		$(use_enable pcre perl-regexp)
}
