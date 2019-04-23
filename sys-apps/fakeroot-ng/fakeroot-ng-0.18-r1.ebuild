# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A utility to run commands with fake root privileges"
HOMEPAGE="https://fakeroot-ng.lingnu.com/"
SRC_URI="mirror://sourceforge/${PN//-/}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-gcc-4.8.2.patch"
)
