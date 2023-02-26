# Copyright 2012-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib multilib-minimal

if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://gitea.treehouse.systems/ariadne/pkgconf.git"
else
	SRC_URI="https://distfiles.dereferenced.org/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="pkg-config compatible replacement with no dependencies other than C99"
HOMEPAGE="https://gitea.treehouse.systems/ariadne/pkgconf"

LICENSE="ISC"
SLOT="0/3"
IUSE="test"

# tests require 'kyua'
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"
RDEPEND="
	!dev-util/pkgconfig
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pkgconf$(get_exeext)
)

src_prepare() {
	default

	[[ ${PV} == "9999" ]] && eautoreconf
	MULTILIB_CHOST_TOOLS+=(
		/usr/bin/pkg-config$(get_exeext)
	)
}

multilib_src_configure() {
	local ECONF_SOURCE="${S}"
	local args=(
		--with-system-includedir="${EPREFIX}/usr/include"
		--with-system-libdir="${EPREFIX}/$(get_libdir):${EPREFIX}/usr/$(get_libdir)"
	)
	econf "${args[@]}"
}

multilib_src_test() {
	unset PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
	default
}

multilib_src_install() {
	default

	dosym pkgconf$(get_exeext) /usr/bin/pkg-config$(get_exeext)
	dosym pkgconf.1 /usr/share/man/man1/pkg-config.1
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
