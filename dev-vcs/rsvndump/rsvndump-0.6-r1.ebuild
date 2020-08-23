# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

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

PATCHES=(
	"${FILESDIR}"/${PN}-0.6-configure-ar.patch
	"${FILESDIR}"/${PN}-0.6-asciidoc-9.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc man) \
		$(use_enable debug)
}
