# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Apple Cinema Display Control"
HOMEPAGE="https://web.archive.org/web/20090725222711/http://technocage.com:80/~caskey/acdctl/"
SRC_URI="http://www.technocage.com/~caskey/acdctl/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_install() {
	einstalldocs
	dobin "${PN}"
}
