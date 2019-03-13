# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DL_ID=2209
inherit cmake-utils

DESCRIPTION="A remote security scanner for Linux (OpenVAS-cli)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P/_beta/+beta}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND="
	>=net-analyzer/openvas-libraries-8.0.4
"
RDEPEND="${DEPEND}
	!net-analyzer/openvas-client
"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${P/_beta/+beta}

src_configure() {
	local mycmakeargs=(
		-DLOCALSTATEDIR="${EPREFIX}"/var
		-DSYSCONFDIR="${EPREFIX}"/etc
	)
	cmake-utils_src_configure
}
