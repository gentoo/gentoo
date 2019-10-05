# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic usr-ldscript

DESCRIPTION="Reiserfs Utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/fs/reiserfs/"
SRC_URI="https://www.kernel.org/pub/linux/utils/fs/reiserfs/${P}.tar.xz
	https://www.kernel.org/pub/linux/kernel/people/jeffm/${PN}/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 -sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}/${PN}-3.6.25-no_acl.patch"
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_configure() {
	append-flags -std=gnu89 #427300
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--libdir="${EPREFIX}/$(get_libdir)"
		--sbindir="${EPREFIX}/sbin"
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodir /usr/$(get_libdir)
	mv "${D}"/$(get_libdir)/pkgconfig "${D}"/usr/$(get_libdir) || die

	if use static-libs ; then
		mv "${D}"/$(get_libdir)/*a "${D}"/usr/$(get_libdir) || die
		gen_usr_ldscript libreiserfscore.so
	else
		find "${D}" -type f \( -name "*.a" -o -name "*.la" \) -delete
	fi
}
