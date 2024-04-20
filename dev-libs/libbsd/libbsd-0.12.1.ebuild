# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/guillemjover.asc
inherit flag-o-matic multilib multilib-minimal verify-sig

DESCRIPTION="Library to provide useful functions commonly found on BSD systems"
HOMEPAGE="https://libbsd.freedesktop.org/wiki/ https://gitlab.freedesktop.org/libbsd/libbsd"
SRC_URI="https://${PN}.freedesktop.org/releases/${P}.tar.xz"
SRC_URI+=" verify-sig? ( https://${PN}.freedesktop.org/releases/${P}.tar.xz.asc )"

LICENSE="BEER-WARE BSD BSD-2 BSD-4 ISC MIT"
SLOT="0"
# Unkeyworded until figured out a solution for bug #925663
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="app-crypt/libmd[${MULTILIB_USEDEP}]"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-3.17
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-guillemjover )"

multilib_src_configure() {
	# bug #911726
	filter-flags -fno-semantic-interposition

	# The build system will install libbsd-ctor.a despite USE="-static-libs"
	# which is correct, see:
	# https://gitlab.freedesktop.org/libbsd/libbsd/commit/c5b959028734ca2281250c85773d9b5e1d259bc8
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	find "${ED}" -type f -name "*.la" -delete || die

	# ld scripts on standalone prefix (RAP) systems should have the prefix
	# stripped from any paths, as the sysroot is automatically prepended.
	local ldscript=${ED}/usr/$(get_libdir)/${PN}$(get_libname)
	if use prefix && ! use prefix-guest && grep -qIF "ld script" "${ldscript}" 2>/dev/null; then
		sed -i "s|${EPREFIX}/|/|g" "${ldscript}" || die
	fi
}
