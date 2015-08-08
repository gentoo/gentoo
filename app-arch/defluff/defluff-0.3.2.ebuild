# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="deflate huffman optimizer"
HOMEPAGE="http://j-o.users.sourceforge.net/
	http://encode.ru/threads/1214-defluff-a-deflate-huffman-optimizer"
SRC_URI="amd64? ( http://encode.ru/attachment.php?attachmentid=1523 -> ${P}-linux-x86_64.zip )
	x86? ( http://encode.ru/attachment.php?attachmentid=1522 -> ${P}-linux-i686.zip )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""
S="${WORKDIR}"

QA_PREBUILT="/opt/bin/${PN}"
RESTRICT="bindist mirror"

src_install() {
	into /opt
	dobin ${PN}
}
