# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic optfeature

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="https://www.lua.org/"
# tarballs produced from ${PV} branches in https://gitweb.gentoo.org/proj/lua-patches.git
SRC_URI="https://dev.gentoo.org/~soap/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="5.3"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated readline"

DEPEND="
	>=app-eselect/eselect-lua-3
	readline? ( sys-libs/readline:= )
	!dev-lang/lua:0"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	if use elibc_musl; then
		# locales on musl are non-functional (#834153)
		# https://wiki.musl-libc.org/open-issues.html#Locale-limitations
		sed -e 's|os.setlocale("pt_BR") or os.setlocale("ptb")|false|g' \
			-i tests/literals.lua || die
	fi
}

src_configure() {
	use deprecated && append-cppflags -DLUA_COMPAT_5_1 -DLUA_COMPAT_5_2
	econf $(use_with readline)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	eselect lua set --if-unset "${PN}${SLOT}"

	optfeature "Lua support for Emacs" app-emacs/lua-mode
}
