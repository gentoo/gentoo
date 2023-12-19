# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tool to write command line option parsing code for C programs"
HOMEPAGE="https://www.gnu.org/software/gengetopt/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3+ public-domain"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${PN}-2.22.6-docdirs.patch
)

src_prepare() {
	default

	sed -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' -i configure.ac || die
	sed -e '/gengetoptdoc_DATA/d' -i Makefile.am || die

	eautoreconf
}
