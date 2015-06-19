# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/physlock/physlock-0.4.5.ebuild,v 1.1 2015/01/10 07:03:14 radhermit Exp $

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="lightweight Linux console locking tool"
HOMEPAGE="https://github.com/muennich/physlock"
SRC_URI="https://github.com/muennich/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4.4-makefile.patch
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
