# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-multilib

DESCRIPTION="Library set needed for build sssd"
HOMEPAGE="https://pagure.io/SSSD/ding-libs"
SRC_URI="https://releases.pagure.org/SSSD/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 GPL-3"
SLOT="0"

KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86 ~amd64-linux"
IUSE="test static-libs"

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )
	"
