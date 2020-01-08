# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Tables available for ophcrack"
HOMEPAGE="http://ophcrack.sourceforge.net/"
SRC_URI="xpfast? ( mirror://sourceforge/ophcrack/tables_xp_free_fast.zip )
		 xpsmall? ( mirror://sourceforge/ophcrack/tables_xp_free_small.zip )
		 vistafree? ( mirror://sourceforge/ophcrack/tables_vista_free.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+xpfast xpsmall +vistafree"

REQUIRED_USE="|| ( xpfast xpsmall vistafree )"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	for i in ${A};
	do
		table=${i#tables_}
		table=${table%.zip}
		mkdir "${S}/${table}"
		cd $_ || die
		unpack "${i}"
	done
}

src_install() {
	dodir /usr/share/ophcrack/
	cp -r "${S}"/* "${ED}"/usr/share/ophcrack/ || die
}
