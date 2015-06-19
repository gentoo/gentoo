# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/snowball-stemmer/snowball-stemmer-0.20140325.ebuild,v 1.4 2014/12/05 10:17:14 ago Exp $

EAPI=5

inherit eutils versionator

# The version number here has been added by Gentoo since upstream does
# not do any versioning.  It is the latest date of files inside
# http://snowball.tartarus.org/dist/libstemmer_c.tgz.
PVDATE=$(get_after_major_version)

DESCRIPTION="This contains all you need to include the snowball stemming algorithms into a C project of your own"
HOMEPAGE="http://snowball.tartarus.org/download.php"
SRC_URI="http://dev.gentoo.org/~graaff/libstemmer_c-${PVDATE}.tgz"

# This will probably be different if this ebuild ends up being used for both
# Java and C.
S="${WORKDIR}/libstemmer_c"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"

# This could be used to package both libstemmer_c and libstemmer_java together.
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}/libstemmer_c-shared-library.patch"
}

src_compile() {
	CC=$(tc-getCC) emake libstemmer.so stemwords || die "Make failed!"

	if use static-libs; then
		CC=$(tc-getCC) AR=$(tc-getAR) emake libstemmer.a || die "Make failed!"
	fi
}

src_install() {
	dodoc README

	dobin stemwords

	doheader include/libstemmer.h

	dolib.so libstemmer.so.0d.0.0
	dolib.so libstemmer.so.0d
	dolib.so libstemmer.so

	use static-libs && dolib.a libstemmer.a
}
