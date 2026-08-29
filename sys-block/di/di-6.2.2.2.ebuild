# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Disk Information Utility"
HOMEPAGE="https://diskinfo-di.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/diskinfo-di/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RESTRICT="test" #405205, #405471

BDEPEND="sys-devel/gettext"

RDEPEND="net-libs/libtirpc:="
