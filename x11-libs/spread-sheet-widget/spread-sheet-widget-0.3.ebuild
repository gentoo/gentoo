# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU Spread Sheet Widget"
HOMEPAGE="https://www.gnu.org/software/ssw/"
SRC_URI="mirror://gnu-alpha/ssw/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-libs/gtk+:3"
RDEPEND="${DEPEND}"
BDEPEND=""
