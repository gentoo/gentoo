# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="a Latin date(1)"
HOMEPAGE="http://hodie.sourceforge.net"
SRC_URI="https://github.com/michiexile/${PN}/archive/${P}.tar.gz
		https://github.com/nephros/hodie/commit/6f08fdd05b4624200ce39519716bca569976362b.patch -> ${P}-classic.patch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="$WORKDIR"/${PN}-${P}

PATCHES="${DISTDIR}"/${P}-classic.patch

src_install() {
	default
	doman hodie.1
}
