# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="GNU macro processor"
HOMEPAGE="https://www.gnu.org/software/m4/m4.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

# remember: cannot dep on autoconf since it needs us
DEPEND="app-arch/xz-utils"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-spawn_h_m4.patch #580688
	eautoreconf

	# Disable gnulib build test that has no impact on the source.
	# Re-enable w/next version bump (and gnulib is updated). #554728
	[[ ${PV} != "1.4.17" ]] && die "re-enable test #554728"
	echo 'exit 0' > tests/test-update-copyright.sh || die
}

src_configure() {
	# Disable automagic dependency over libsigsegv; see bug #278026
	export ac_cv_libsigsegv=no

	local myconf=""
	[[ ${USERLAND} != "GNU" ]] && myconf="--program-prefix=g"
	econf --enable-changeword ${myconf}
}

src_test() {
	[[ -d /none ]] && die "m4 tests will fail with /none/" #244396
	emake check
}

src_install() {
	default
	# autoconf-2.60 for instance, first checks gm4, then m4.  If we don't have
	# gm4, it might find gm4 from outside the prefix on for instance Darwin
	use prefix && dosym /usr/bin/m4 /usr/bin/gm4
	if use examples ; then
		docinto examples
		dodoc examples/*
		rm -f "${ED}"/usr/share/doc/${PF}/examples/Makefile*
	fi
}
