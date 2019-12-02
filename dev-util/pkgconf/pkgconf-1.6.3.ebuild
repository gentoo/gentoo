# Copyright 2012-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://git.sr.ht/~kaniini/pkgconf"
else
	SRC_URI="http://distfiles.dereferenced.org/${PN}/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86"
fi

DESCRIPTION="pkg-config compatible replacement with no dependencies other than ANSI C89"
HOMEPAGE="https://git.sr.ht/~kaniini/pkgconf"

LICENSE="ISC"
SLOT="0/3"
IUSE="+pkg-config test"

# tests require 'kyua'
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"
RDEPEND="
	pkg-config? (
		!dev-util/pkgconfig
		!dev-util/pkg-config-lite
		!dev-util/pkgconfig-openbsd[pkg-config]
	)
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pkgconf
)

src_prepare() {
	default

	[[ ${PV} == "9999" ]] && eautoreconf
	if use pkg-config; then
		MULTILIB_CHOST_TOOLS+=(
			/usr/bin/pkg-config
		)
	fi
}

multilib_src_configure() {
	local ECONF_SOURCE="${S}"
	econf
}

multilib_src_test() {
	unset PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
	default
}

multilib_src_install() {
	default

	if use pkg-config; then
		dosym pkgconf /usr/bin/pkg-config
		dosym pkgconf.1 /usr/share/man/man1/pkg-config.1
	else
		rm "${ED}"/usr/share/aclocal/pkg.m4 || die
		rmdir "${ED}"/usr/share/aclocal || die
		rm "${ED}"/usr/share/man/man7/pkg.m4.7 || die
		rmdir "${ED}"/usr/share/man/man7 || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
