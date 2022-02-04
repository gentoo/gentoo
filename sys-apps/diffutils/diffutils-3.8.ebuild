# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Tools to make diffs and compare files"
HOMEPAGE="https://www.gnu.org/software/diffutils/"
SRC_URI="mirror://gnu/diffutils/${P}.tar.xz
	https://alpha.gnu.org/gnu/diffutils/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static"

BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}/ppc-musl.patch" )

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
