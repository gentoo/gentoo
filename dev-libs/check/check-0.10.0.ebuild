# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/check/check-0.10.0.ebuild,v 1.1 2015/08/03 08:57:55 jer Exp $

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES="all"

inherit autotools autotools-multilib eutils

DESCRIPTION="A unit test framework for C"
HOMEPAGE="http://sourceforge.net/projects/check/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs subunit"

DEPEND="subunit? ( >=dev-python/subunit-0.0.10-r1[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

pkg_setup() {
	# See multilib_src_test(), disable sleep()-based tests because they
	# just take a long time doing pretty much nothing.
	export CPPFLAGS="-DTIMEOUT_TESTS_ENABLED=0 ${CPPFLAGS}"
}

src_prepare() {
	sed -i -e '/^docdir =/d' {.,doc}/Makefile.am || die

	# fix out-of-sourcedir build having inconsistent check.h files, for
	# example breaks USE=subunit.
	rm src/check.h || die

	# Fix automake warnings being treated as errors, bug #420373
	sed -i -e s/-Werror// configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		$(use_enable subunit)
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
	)
	autotools-multilib_src_configure
}

multilib_src_test() {
	elog "-DTIMEOUT_TESTS_ENABLED=0 has been prepended to CPPFLAGS. To run the"
	elog "entire testsuite for dev-libs/check, ensure that"
	elog "-DTIMEOUT_TESTS_ENABLED=1 is in your CPPFLAGS."
	default_src_test
}

src_install() {
	autotools-multilib_src_install
	dodoc AUTHORS *ChangeLog* NEWS README THANKS TODO

	rm -f "${ED}"/usr/share/doc/${PF}/COPYING* || die
}
