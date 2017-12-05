# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils gnustep-2

MY_P=${P/p/P}

S=${WORKDIR}/${MY_P}

DESCRIPTION="A set of Objective-C classes that model a mail system"
HOMEPAGE="http://www.nongnu.org/gnustep-nonfsf/gnumail/index.html"
SRC_URI="mirror://nongnu/gnustep-nonfsf/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 Elm"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}"

src_install() {
	gnustep-base_src_install

	cd "${S}"/Documentation
	dodoc AUTHORS README TODO
	docinto rfc
	dodoc RFC/*
}
