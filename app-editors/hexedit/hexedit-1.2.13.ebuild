# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="View and edit files in hex or ASCII"
HOMEPAGE="http://rigaux.org/hexedit.html"
SRC_URI="http://rigaux.org/${P}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.13-tinfo.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	dobin hexedit
	doman hexedit.1
	dodoc Changes
}
