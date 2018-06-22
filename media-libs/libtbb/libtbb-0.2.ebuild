# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="An open source implemention of the proprietary TeamSpeak2 protocol"
HOMEPAGE="https://sourceforge.net/projects/teambb/"
SRC_URI="mirror://sourceforge/teambb/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_prepare() {
	default

	# Running autotools, because the configure scripts seems to be deprecated
	# and complains about several wrong parameters
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
