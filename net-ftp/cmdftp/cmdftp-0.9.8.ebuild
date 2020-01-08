# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Light weight, yet robust command line FTP client with shell-like
functions."
HOMEPAGE="https://savannah.nongnu.org/projects/cmdftp/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=( NEWS README AUTHORS )

src_configure() {
	econf --enable-largefile
}
