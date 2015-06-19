# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/openvas-cli/openvas-cli-1.3.1.ebuild,v 1.3 2015/02/14 14:38:49 jlec Exp $

EAPI=5

inherit cmake-utils

DL_ID=1803

DESCRIPTION="A remote security scanner for Linux (OpenVAS-cli)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

RDEPEND="
	>=net-analyzer/openvas-libraries-7.0.7
	!net-analyzer/openvas-client"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DLOCALSTATEDIR="${EPREFIX}"/var
		-DSYSCONFDIR="${EPREFIX}"/etc
	)
	cmake-utils_src_configure
}
