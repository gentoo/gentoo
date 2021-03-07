# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic libtool toolchain-funcs multilib-minimal usr-ldscript

DESCRIPTION="access control list utilities, libraries and headers"
HOMEPAGE="https://savannah.nongnu.org/projects/acl"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="nls static-libs"

RDEPEND="
	>=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

pkg_setup() {
	# filter out -flto flags as they break getfacl/setfacl binaries
	# (bug #667372)
	filter-flags -flto*
}

src_prepare() {
	default
	elibtoolize #580792
}

multilib_src_configure() {
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
	# https://bugs.gentoo.org/772356
	multilib_is_native_abi && default
}

multilib_src_install() {
	default

	# move shared libs to /
	gen_usr_ldscript -a acl
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -type f -name "*.la" -delete || die
	fi
}
