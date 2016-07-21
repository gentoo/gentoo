# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="linux port of Thierry Zollers' BTCrack"
HOMEPAGE="https://github.com/mikeryan/btcrack"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mikeryan/btcrack.git"
	inherit git-r3
	KEYWORDS=""
else
	#SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr install
}
