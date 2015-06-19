# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/openvas-cli/openvas-cli-1.4.0.ebuild,v 1.1 2015/04/06 10:56:28 jlec Exp $

EAPI=5

inherit cmake-utils

DL_ID=1987

DESCRIPTION="A remote security scanner for Linux (OpenVAS-cli)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P/_beta/+beta}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS=" ~amd64 ~arm ~ppc ~x86"
IUSE=""

RDEPEND="
	>=net-analyzer/openvas-libraries-8.0.1
	!net-analyzer/openvas-client"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${P/_beta/+beta}

src_configure() {
	local mycmakeargs=(
		-DLOCALSTATEDIR="${EPREFIX}"/var
		-DSYSCONFDIR="${EPREFIX}"/etc
	)
	cmake-utils_src_configure
}
