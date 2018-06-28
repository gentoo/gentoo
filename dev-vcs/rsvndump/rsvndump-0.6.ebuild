# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Dump a remote Subversion repository"
HOMEPAGE="http://rsvndump.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3+ BSD public-domain"  # rsvndump, snappy-c, critbit89
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="dev-vcs/subversion
	dev-libs/apr
	dev-libs/apr-util
	sys-devel/gettext"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto
		>=app-text/asciidoc-8.4 )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_configure() {
	econf \
		$(use_enable doc man) \
		$(use_enable debug)
}
