# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A collection of tools that operate on patch files"
HOMEPAGE="http://cyberelk.net/tim/patchutils/"
SRC_URI="http://cyberelk.net/tim/data/patchutils/stable/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# testsuite makes use of gendiff(1) that comes from rpm, thus if the user wants
# to run tests, it should install that package as well.
DEPEND="test? ( app-arch/rpm )"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.3-format-security.patch"
)

src_test() {
	# See bug 605952.
	make check || die
}
