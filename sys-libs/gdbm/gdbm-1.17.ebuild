# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic multilib multilib-minimal

DESCRIPTION="Standard GNU database libraries"
HOMEPAGE="https://www.gnu.org/software/gdbm/"
SRC_URI="mirror://gnu/gdbm/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/6" # libgdbm.so version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+berkdb nls +readline static-libs"

DEPEND="
	readline? ( sys-libs/readline:0=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/gdbm-1.17-fix-gdbmsync.patch )

src_prepare() {
	default
	eautoreconf
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

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete || die
	fi
	mv "${ED%/}"/usr/include/gdbm/gdbm.h "${ED%/}"/usr/include/ || die
}
