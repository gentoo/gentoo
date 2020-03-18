# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Get EDID information from a PnP monitor"
HOMEPAGE="http://www.polypux.org/projects/read-edid/"
SRC_URI="http://www.polypux.org/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"

src_configure() {
	econf --mandir=/usr/share/man
}
