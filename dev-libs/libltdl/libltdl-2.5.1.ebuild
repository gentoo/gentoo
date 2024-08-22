# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with dev-build/libtool.

inherit multilib-minimal flag-o-matic

MY_P="libtool-${PV}"

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="https://www.gnu.org/software/libtool/"
if ! [[ $(( $(ver_cut 2) % 2 )) -eq 0 ]] ; then
	SRC_URI="https://alpha.gnu.org/gnu/libtool/${MY_P}.tar.xz"
else
	SRC_URI="mirror://gnu/libtool/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

S="${WORKDIR}"/${MY_P}/libltdl

LICENSE="GPL-2"
SLOT="0"
IUSE="static-libs"
# libltdl doesn't have a testsuite.  Don't bother trying.
RESTRICT="test"

BDEPEND="app-arch/xz-utils"

multilib_src_configure() {
	# bug #907427
	filter-lto

	append-lfs-flags
	ECONF_SOURCE="${S}" \
	econf \
		--enable-ltdl-install \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# While the libltdl.la file is not used directly, the m4 ltdl logic
	# keys off of its existence when searching for ltdl support. # bug #293921
	#use static-libs || find "${D}" -name libltdl.la -delete
}
