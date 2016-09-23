# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils qmake-utils

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="http://www.gnupg.org/related_software/gpgme"
SRC_URI="mirror://gnupg/gpgme/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="1/11" # subslot = soname major version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="common-lisp static-libs cxx qt5 test"

RDEPEND="app-crypt/gnupg
	>=dev-libs/libassuan-2.0.2
	>=dev-libs/libgpg-error-1.11
	qt5? ( dev-qt/qtcore:5 )"
		#doc? ( app-doc/doxygen[dot] )
DEPEND="${RDEPEND}
	qt5? (
		test? ( dev-qt/qttest:5 )
	)"

REQUIRED_USE="qt5? ( cxx )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.8-et_EE.patch
)

src_prepare() {
	default

	# remove non working tests
	sed -i 's/\tt-sig-notation\$(EXEEXT)/\t/' tests/gpg/Makefile.in || die
	sed -i 's/ t-encrypt\$(EXEEXT)//' lang/qt/tests/Makefile.in || die
}

src_configure() {
	local languages=( "cl" )
	use cxx && languages+=( "cpp" )
	if use qt5; then
		languages+=( "qt" )
		#use doc ||
		export DOXYGEN=
	fi

	econf \
		--includedir="${EPREFIX}/usr/include/gpgme" \
		--enable-languages="${languages[*]}" \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	use common-lisp || rm -fr "${ED}usr/share/common-lisp"
}
