# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P="abcMIDI-${PV}"
DESCRIPTION="Programs for processing ABC music notation files"
HOMEPAGE="https://ifdo.ca/~seymour/runabc/top.html"
SRC_URI="https://ifdo.ca/~seymour/runabc/${MY_P}.zip"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

BDEPEND="app-arch/unzip"

src_prepare() {
	default
	sed -i "s:-O2::" configure.ac || die
	sed -i "s:@datarootdir@/doc/abcmidi:@docdir@:" Makefile.in || die
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/876421
	# https://github.com/sshlien/abcmidi/issues/9
	filter-lto

	default
}

src_install() {
	default

	if use examples ; then
		docinto examples
		dodoc samples/*.abc
	fi
}
