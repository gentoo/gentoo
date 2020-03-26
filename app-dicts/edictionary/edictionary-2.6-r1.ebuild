# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="edict"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Command line dictionary and thesaurus"
HOMEPAGE="http://edictionary.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=""
DEPEND="dev-lang/perl"

S="${WORKDIR}/${MY_PN}"

src_install() {
	make prefix="${ED}/usr/bin" install
	dodoc Changelog ReleaseNotes README TODO
}
