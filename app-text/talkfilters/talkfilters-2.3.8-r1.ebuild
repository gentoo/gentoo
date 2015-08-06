# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/talkfilters/talkfilters-2.3.8-r1.ebuild,v 1.3 2015/08/06 07:20:52 ago Exp $

EAPI=5

inherit eutils

DESCRIPTION="Convert ordinary English text into text that mimics a stereotyped or otherwise humorous dialect"
HOMEPAGE="http://www.hyperrealm.com/talkfilters/talkfilters.html"
SRC_URI="http://www.hyperrealm.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
	)

src_prepare() {
	epatch "${PATCHES[@]}"
}
