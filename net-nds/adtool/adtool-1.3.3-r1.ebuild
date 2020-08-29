# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools out-of-source

DESCRIPTION="Utility for Active Directory administration"
HOMEPAGE="http://gp2x.org/adtool/"
SRC_URI="http://gp2x.org/adtool/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="net-nds/openldap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-bfr-overflow.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-automake.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}
