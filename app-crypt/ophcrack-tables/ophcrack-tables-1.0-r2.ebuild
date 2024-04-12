# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tables available for ophcrack"
HOMEPAGE="https://ophcrack.sourceforge.io"
SRC_URI="
	xpfast? ( https://downloads.sourceforge.net/ophcrack/tables_xp_free_fast.zip )
	xpsmall? ( https://downloads.sourceforge.net/ophcrack/tables_xp_free_small.zip )
	vistafree? ( https://downloads.sourceforge.net/ophcrack/tables_vista_free.zip )"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+xpfast xpsmall +vistafree"
REQUIRED_USE="|| ( xpfast xpsmall vistafree )"

BDEPEND="app-arch/unzip"

src_unpack() {
	local i table
	for i in ${A}; do
		table=${i#tables_}
		table=${table%.zip}
		mkdir "${S}"/${table} || die
		cd $_ || die
		unpack "${i}"
	done
}

src_install() {
	insinto /usr/share/ophcrack
	doins -r .
}
