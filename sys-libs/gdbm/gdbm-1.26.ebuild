# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gdbm.asc
inherit libtool multilib-minimal multiprocessing verify-sig

DESCRIPTION="Standard GNU database libraries"
HOMEPAGE="https://www.gnu.org/software/gdbm/"
SRC_URI="
	mirror://gnu/gdbm/${P}.tar.gz
	verify-sig? ( mirror://gnu/gdbm/${P}.tar.gz.sig )
"

LICENSE="GPL-3+ GPL-2+ FDL-1.3+"
SLOT="0/6" # libgdbm.so version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+berkdb nls +readline static-libs test"
RESTRICT="!test? ( test )"

DEPEND="readline? ( sys-libs/readline:=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-util/dejagnu )
	verify-sig? ( >=sec-keys/openpgp-keys-gdbm-20250323 )
"

src_prepare() {
	default

	# gdbm ships with very old libtool files, regen to avoid
	# errors when cross-compiling.
	elibtoolize
}

multilib_src_configure() {
	# gdbm doesn't appear to use either of these libraries
	export ac_cv_lib_dbm_main=no ac_cv_lib_ndbm_main=no

	local myeconfargs=(
		--includedir="${EPREFIX}"/usr/include/gdbm
		$(use_enable berkdb libgdbm-compat)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_with readline)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	emake -Onone check TESTSUITEFLAGS="--jobs=$(get_makeopts_jobs)"
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete || die
	fi

	mv "${ED}"/usr/include/gdbm/gdbm.h "${ED}"/usr/include/ || die
}
