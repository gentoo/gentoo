# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Query VIA IDE controllers for various information"
HOMEPAGE="http://www.reactivated.net/software/viaideinfo"
SRC_URI="http://www.reactivated.net/software/viaideinfo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=sys-apps/pciutils-2.2.0"
RDEPEND="${DEPEND}"
DOCS=(
	ChangeLog NEWS README THANKS
)
