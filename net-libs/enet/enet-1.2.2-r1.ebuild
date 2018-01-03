# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="relatively thin, simple and robust network communication layer on top of UDP"
HOMEPAGE="http://enet.bespin.org/"
SRC_URI="http://enet.bespin.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}
