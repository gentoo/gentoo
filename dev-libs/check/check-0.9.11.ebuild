# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_PRUNE_LIBTOOL_FILES="all"

inherit autotools autotools-multilib eutils

DESCRIPTION="A unit test framework for C"
HOMEPAGE="http://sourceforge.net/projects/check/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs subunit"

DEPEND="subunit? ( dev-python/subunit )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.9.10-AM_PATH_CHECK.patch

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

src_install() {
	autotools-multilib_src_install
	dodoc AUTHORS *ChangeLog* NEWS README THANKS TODO

	rm -f "${ED}"/usr/share/doc/${PF}/COPYING* || die
}
