# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit prefix

DESCRIPTION="Chained EPREFIX bootstrapping utility"
HOMEPAGE="https://dev.gentoo.org/~mduft"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~ppc-aix ~x64-cygwin ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	cp "${FILESDIR}"/prefix-chain-setup.in "${T}"/prefix-chain-setup
	eprefixify "${T}"/prefix-chain-setup
	dobin "${T}"/prefix-chain-setup
}
