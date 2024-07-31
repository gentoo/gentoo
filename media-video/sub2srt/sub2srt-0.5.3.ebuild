# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool to convert several subtitle formats into subviewer srt"
HOMEPAGE="http://www.robelix.com/sub2srt/"
SRC_URI="http://www.robelix.com/sub2srt/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-lang/perl"

src_install() {
	dobin sub2srt
	dodoc README
}
