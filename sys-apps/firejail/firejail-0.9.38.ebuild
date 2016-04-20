# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+seccomp"

src_prepare() {
	epatch "${FILESDIR}"/${P}-sysmacros.patch
}

src_configure() {
	econf $(use_enable seccomp)
}
