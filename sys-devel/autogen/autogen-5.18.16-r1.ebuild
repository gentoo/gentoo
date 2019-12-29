# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Program and text file generation"
HOMEPAGE="https://www.gnu.org/software/autogen/"
SRC_URI="mirror://gnu/${PN}/rel${PV}/${P}.tar.xz
	https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob_plain;f=lib/verify.h;h=3b57ddee0acffd23cc51bc8910a15cf879f90619;hb=537a5511ab0b1326e69b32f87593a50aedb8a589 -> ${P}-gnulib-3b57ddee0acffd23cc51bc8910a15cf879f90619-lib-verify.h"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="libopts static-libs"

RDEPEND=">=dev-scheme/guile-2.0:=
	dev-libs/libxml2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.18.16-no-werror.patch
	"${FILESDIR}"/${PN}-5.18.16-rpath.patch
)

src_prepare() {
	# no-werror.patch fixes both configure{.ac,}
	# avoid configure echeck
	touch -r configure.ac orig.configure.ac || die
	touch -r configure    orig.configure || die

	default

	touch -r orig.configure.ac configure.ac || die
	touch -r orig.configure    configure || die

	# missing tarball file
	cp "${DISTDIR}"/${P}-gnulib-3b57ddee0acffd23cc51bc8910a15cf879f90619-lib-verify.h autoopts/verify.h || die
}

src_configure() {
	# suppress possibly incorrect -R flag
	export ag_cv_test_ldflags=

	# autogen requires run-time sanity of regex and string functions.
	# Use defaults of linux-glibc until we need somethig more advanced.
	if tc-is-cross-compiler ; then
		export ag_cv_run_strcspn=no
		export libopts_cv_with_libregex=yes
	fi

	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	if ! use libopts ; then
		rm "${ED}"/usr/share/autogen/libopts-*.tar.gz || die
	fi
}
