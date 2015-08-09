# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils
MY_P=${PN}-v${PV}

DESCRIPTION="Small parser which translates a wiki dialect to HTML"
HOMEPAGE="http://www.public-software-group.org/rocketwiki"
SRC_URI="http://www.public-software-group.org/pub/projects/rocketwiki/liquid_feedback_edition/v${PV}/${MY_P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/gmp"
DEPEND="${RDEPEND}
	dev-haskell/parsec
	dev-lang/ghc"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-utf8.patch
}

src_install() {
	dobin ${PN}{,-compat}
}
