# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="View and edit files in hex or ASCII"
HOMEPAGE="http://rigaux.org/hexedit.html"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
EGIT_REPO_URI="https://github.com/pixel/hexedit.git"
else
SRC_URI="https://github.com/pixel/hexedit/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dobin hexedit
	doman hexedit.1
	dodoc Changes
}
