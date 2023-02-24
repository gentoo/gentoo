# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/diffutils.asc
inherit flag-o-matic verify-sig

DESCRIPTION="Tools to make diffs and compare files"
HOMEPAGE="https://www.gnu.org/software/diffutils/"
SRC_URI="mirror://gnu/diffutils/${P}.tar.xz
	https://alpha.gnu.org/gnu/diffutils/${P}.tar.xz
	verify-sig? (
		mirror://gnu/diffutils/${P}.tar.xz.sig
		https://alpha.gnu.org/gnu/diffutils/${P}.tar.xz.sig
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static"

BDEPEND="nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-diffutils )"

PATCHES=(
	"${FILESDIR}/ppc-musl.patch"
	"${FILESDIR}/loong-fix-build.patch"
)

src_prepare() {
	default

	# touch generated files after patching m4, to avoid activating maintainer
	# mode
	# remove when loong-fix-build.patch is no longer necessary
	touch ./aclocal.m4 lib/config.hin ./configure || die
	find . -name Makefile.in -exec touch {} + || die
}

src_configure() {
	use static && append-ldflags -static

	# Disable automagic dependency over libsigsegv; see bug #312351.
	export ac_cv_libsigsegv=no

	# required for >=glibc-2.26, bug #653914
	use elibc_glibc && export gl_cv_func_getopt_gnu=yes

	local myeconfargs=(
		--with-packager="Gentoo"
		--with-packager-version="${PVR}"
		--with-packager-bug-reports="https://bugs.gentoo.org/"
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}
