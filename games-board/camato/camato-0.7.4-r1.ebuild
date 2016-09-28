# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit versionator

MY_PV=$(replace_all_version_separators _)
DESCRIPTION="A map editor for the game gnocatan"
HOMEPAGE="http://yusei.ragondux.com/loisirs_jdp_catane_camato-en.html"
SRC_URI="http://yusei.ragondux.com/files/gnocatan/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-ruby/ruby-gtk2"
RDEPEND=${DEPEND}

src_prepare() {
	default

	rm -f Makefile || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r *.rb img
	dodoc ChangeLog README
}
