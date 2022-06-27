# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/findutils.asc
inherit flag-o-matic python-any-r1 verify-sig

DESCRIPTION="GNU utilities for finding files"
HOMEPAGE="https://www.gnu.org/software/findutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls selinux static test"
RESTRICT="!test? ( test )"

RDEPEND="selinux? ( sys-libs/libselinux )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )"
BDEPEND="nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-findutils )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# Don't build or install locate because it conflicts with mlocate,
	# which is a secure version of locate.  See bug 18729
	sed \
		-e '/^SUBDIRS/s@locate@@' \
		-e '/^built_programs/s@ frcode locate updatedb@@' \
		-i Makefile.in || die

	default
}

src_configure() {
	if use static; then
		append-flags -pthread
		append-ldflags -static
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		# https://lists.gnu.org/archive/html/bug-findutils/2021-01/msg00050.html
		# https://lists.gnu.org/archive/html/bug-findutils/2021-01/msg00051.html
		append-cppflags '-D__nonnull\(X\)='
	fi

	local myeconfargs=(
		--with-packager="Gentoo"
		--with-packager-version="${PVR}"
		--with-packager-bug-reports="https://bugs.gentoo.org/"
		$(use_enable nls)
		$(use_with selinux)
		--libexecdir='$(libdir)'/find
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	local -x SANDBOX_PREDICT=${SANDBOX_PREDICT}
	addpredict /
	default
}

src_compile() {
	# We don't build locate, but the docs want a file in there.
	emake -C locate dblocation.texi
	default
}
