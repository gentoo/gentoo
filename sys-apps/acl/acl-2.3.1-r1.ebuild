# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic libtool multilib-minimal usr-ldscript

DESCRIPTION="Access control list utilities, libraries, and headers"
HOMEPAGE="https://savannah.nongnu.org/projects/acl"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls static-libs"

RDEPEND="
	>=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	default

	# bug #580792
	elibtoolize
}

multilib_src_configure() {
	# Filter out -flto flags as they break getfacl/setfacl binaries
	# bug #667372
	filter-flags -flto*

	# Broken with FORTIFY_SOURCE=3
	# Our toolchain sets F_S=2 by default w/ >= -O2, so we need
	# to unset F_S first, then explicitly set 2, to negate any default
	# and anything set by the user if they're choosing 3 (or if they've
	# modified GCC to set 3).
	#
	# Refs:
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=104964
	# https://savannah.nongnu.org/bugs/index.php?62519
	# bug #847280
	if is-flagq '-O[23]' || is-flagq '-Ofast' ; then
		# We can't unconditionally do this b/c we fortify needs
		# some level of optimisation.
		filter-flags -D_FORTIFY_SOURCE=3
		append-cppflags -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
	fi

	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		$(use_enable static-libs static)
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable nls)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# Tests call native binaries with an LD_PRELOAD wrapper
	# bug #772356
	multilib_is_native_abi && default
}

multilib_src_install() {
	default

	# Move shared libs to /
	gen_usr_ldscript -a acl
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -type f -name "*.la" -delete || die
	fi
}
