# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal libtool

DESCRIPTION="Library for manipulating Unicode and C strings according to Unicode standard"
HOMEPAGE="https://www.gnu.org/software/libunistring/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="|| ( LGPL-3+ GPL-2+ ) || ( FDL-1.2 GPL-3+ )"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-nodocs.patch
	"${FILESDIR}"/${PN}-test.patch
)

src_prepare() {
	default
	elibtoolize  # for Solaris shared libraries
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	default

	if use doc; then
		docinto html
		dodoc doc/*.html
		doinfo doc/*.info
	fi

	find "${ED}" -name '*.la' -delete || die
}
