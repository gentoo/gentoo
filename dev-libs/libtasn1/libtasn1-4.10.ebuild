# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal libtool

DESCRIPTION="ASN.1 library"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/6" # subslot = libtasn1 soname version
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs valgrind"

DEPEND=">=dev-lang/perl-5.6
	sys-apps/help2man
	virtual/yacc"
RDEPEND="
	valgrind? ( dev-util/valgrind )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r16
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

pkg_setup() {
	if use doc; then
		DOCS+=( doc/libtasn1.pdf )
		HTML_DOCS=( doc/reference/html/. )
	fi
}

src_prepare() {
	default
	elibtoolize  # for Solaris shared library
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(multilib_native_use_enable valgrind valgrind-tests)
}
