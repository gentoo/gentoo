# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit base bash-completion-r1

DESCRIPTION="A nice emerge.log parser"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl"
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~x64-solaris"
IUSE=""

DEPEND="dev-lang/perl
	 dev-perl/Date-Manip
	 dev-perl/libwww-perl"
RDEPEND="${DEPEND}"

# Populate the patches array for any patches for -rX releases
PATCHES=(
	"${FILESDIR}"/${P}-sync.patch
	"${FILESDIR}"/${P}-sandbox.patch
)

src_install() {
	dobin genlop
	dodoc README Changelog
	doman genlop.1
	newbashcomp genlop.bash-completion genlop
}
