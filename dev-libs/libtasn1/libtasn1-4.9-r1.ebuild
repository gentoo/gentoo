# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="ASN.1 library"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/6" # subslot = libtasn1 soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs"

DEPEND=">=dev-lang/perl-5.6
	sys-apps/help2man
	virtual/yacc"
RDEPEND="
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r16
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)
DOCS=( AUTHORS ChangeLog NEWS README THANKS )

pkg_setup() {
	if use doc; then
		DOCS+=( doc/libtasn1.pdf )
		HTML_DOCS=( doc/reference/html/. )
	fi
}

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs
	[[ "${VALGRIND_TESTS}" == "0" ]] && myeconfargs+=( --disable-valgrind-tests )
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}
