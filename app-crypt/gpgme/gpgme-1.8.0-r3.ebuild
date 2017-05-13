# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{4,5} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 flag-o-matic ltprune qmake-utils

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="http://www.gnupg.org/related_software/gpgme"
SRC_URI="mirror://gnupg/gpgme/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="1/11" # subslot = soname major version
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="common-lisp cxx python qt5 static-libs"

COMMON_DEPEND="app-crypt/gnupg
	>=dev-libs/libassuan-2.0.2
	>=dev-libs/libgpg-error-1.17
	python? ( ${PYTHON_DEPS} )
	qt5? ( dev-qt/qtcore:5 )"
	#doc? ( app-doc/doxygen[dot] )
DEPEND="${COMMON_DEPEND}
	python? ( dev-lang/swig )
	qt5? ( dev-qt/qttest:5 )"
RDEPEND="${COMMON_DEPEND}
	cxx? (
		!<kde-apps/gpgmepp-4.14.11_pre20160611:4
		!kde-apps/gpgmepp:5
		!<kde-apps/kdepimlibs-4.14.10_p20160611:4
		!=kde-apps/kdepimlibs-4.14.11_pre20160211*:4
	)"

REQUIRED_USE="qt5? ( cxx ) python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.8-et_EE.patch
	"${FILESDIR}"/${P}-cmake.patch
)

do_python() {
	if use python; then
		pushd lang/python > /dev/null || die
		distutils-r1_src_${EBUILD_PHASE}
		popd > /dev/null
	fi
}

src_prepare() {
	default
	do_python
}

src_configure() {
	local languages=()
	use common-lisp && languages+=( "cl" )
	use cxx && languages+=( "cpp" )
	if use qt5; then
		languages+=( "qt" )
		#use doc ||
		export DOXYGEN=true
		export MOC="$(qt5_get_bindir)/moc"
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		# FIXME: I don't know how to select on C++11 (libc++) here, but
		# I do know all Darwin users are using C++11.  This should also
		# apply to GCC 4.7+ with libc++, and basically anyone targetting
		# it.

		# The C-standard doesn't define strdup, and C++11 drops it
		# resulting in an implicit declaration of strdup error.  Since
		# it is in POSIX raise the feature set to that.
		append-cxxflags -D_POSIX_C_SOURCE=200112L

		# Work around bug 601834
		use python && append-cflags -D_DARWIN_C_SOURCE
	fi

	econf \
		--enable-languages="${languages[*]}" \
		$(use_enable static-libs static)

	use python && make -C lang/python prepare

	do_python
}

src_compile() {
	default
	do_python
}

src_install() {
	default
	do_python
	prune_libtool_files

	# backward compatibility for gentoo
	# in the past we had slots
	dodir /usr/include/gpgme
	dosym ../gpgme.h /usr/include/gpgme/gpgme.h
}
