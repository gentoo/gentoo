# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Nice emerge.log parser"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="
	dev-lang/perl
	dev-perl/Date-Manip
	dev-perl/libwww-perl
"
RDEPEND="${DEPEND}"

src_install() {
	dobin genlop
	dodoc README Changelog
	doman genlop.1
	newbashcomp genlop.bash-completion genlop
}
