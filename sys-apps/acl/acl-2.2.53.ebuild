# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit libtool ltprune toolchain-funcs multilib-minimal usr-ldscript

DESCRIPTION="access control list utilities, libraries and headers"
HOMEPAGE="https://savannah.nongnu.org/projects/acl"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="nls static-libs"

RDEPEND="
	>=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

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

multilib_src_install() {
	default

	# move shared libs to /
	gen_usr_ldscript -a acl
}

multilib_src_install_all() {
	use static-libs || prune_libtool_files --all
}
