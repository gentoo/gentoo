# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils versionator

# The version number here has been added by Gentoo since upstream does
# not do any versioning.  It is the latest date of files inside
# http://snowball.tartarus.org/dist/libstemmer_c.tgz.
PVDATE=$(get_after_major_version)

DESCRIPTION="All you need to include the snowball stemming algorithms into a C project"
HOMEPAGE="https://snowballstem.org/"
SRC_URI="https://dev.gentoo.org/~graaff/libstemmer_c-${PVDATE}.tgz"

# This will probably be different if this ebuild ends up being used for both
# Java and C.
S="${WORKDIR}/libstemmer_c"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"

# This could be used to package both libstemmer_c and libstemmer_java together.
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}/libstemmer_c-shared-library.patch"
}

src_compile() {
	CC=$(tc-getCC) emake libstemmer.so stemwords

	if use static-libs; then
		CC=$(tc-getCC) AR=$(tc-getAR) emake libstemmer.a
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
